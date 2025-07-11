# bash completion for charm                                -*- shell-script -*-

__charm_debug()
{
    if [[ -n ${BASH_COMP_DEBUG_FILE:-} ]]; then
        echo "$*" >> "${BASH_COMP_DEBUG_FILE}"
    fi
}

# Homebrew on Macs have version 1.3 of bash-completion which doesn't include
# _init_completion. This is a very minimal version of that function.
__charm_init_completion()
{
    COMPREPLY=()
    _get_comp_words_by_ref "$@" cur prev words cword
}

__charm_index_of_word()
{
    local w word=$1
    shift
    index=0
    for w in "$@"; do
        [[ $w = "$word" ]] && return
        index=$((index+1))
    done
    index=-1
}

__charm_contains_word()
{
    local w word=$1; shift
    for w in "$@"; do
        [[ $w = "$word" ]] && return
    done
    return 1
}

__charm_handle_go_custom_completion()
{
    __charm_debug "${FUNCNAME[0]}: cur is ${cur}, words[*] is ${words[*]}, #words[@] is ${#words[@]}"

    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local out requestComp lastParam lastChar comp directive args

    # Prepare the command to request completions for the program.
    # Calling ${words[0]} instead of directly charm allows to handle aliases
    args=("${words[@]:1}")
    # Disable ActiveHelp which is not supported for bash completion v1
    requestComp="CHARM_ACTIVE_HELP=0 ${words[0]} __completeNoDesc ${args[*]}"

    lastParam=${words[$((${#words[@]}-1))]}
    lastChar=${lastParam:$((${#lastParam}-1)):1}
    __charm_debug "${FUNCNAME[0]}: lastParam ${lastParam}, lastChar ${lastChar}"

    if [ -z "${cur}" ] && [ "${lastChar}" != "=" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go method.
        __charm_debug "${FUNCNAME[0]}: Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __charm_debug "${FUNCNAME[0]}: calling ${requestComp}"
    # Use eval to handle any environment variables and such
    out=$(eval "${requestComp}" 2>/dev/null)

    # Extract the directive integer at the very end of the output following a colon (:)
    directive=${out##*:}
    # Remove the directive
    out=${out%:*}
    if [ "${directive}" = "${out}" ]; then
        # There is not directive specified
        directive=0
    fi
    __charm_debug "${FUNCNAME[0]}: the completion directive is: ${directive}"
    __charm_debug "${FUNCNAME[0]}: the completions are: ${out}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        # Error code.  No completion.
        __charm_debug "${FUNCNAME[0]}: received error from custom completion go code"
        return
    else
        if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
            if [[ $(type -t compopt) = "builtin" ]]; then
                __charm_debug "${FUNCNAME[0]}: activating no space"
                compopt -o nospace
            fi
        fi
        if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
            if [[ $(type -t compopt) = "builtin" ]]; then
                __charm_debug "${FUNCNAME[0]}: activating no file completion"
                compopt +o default
            fi
        fi
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local fullFilter filter filteringCmd
        # Do not use quotes around the $out variable or else newline
        # characters will be kept.
        for filter in ${out}; do
            fullFilter+="$filter|"
        done

        filteringCmd="_filedir $fullFilter"
        __charm_debug "File filtering command: $filteringCmd"
        $filteringCmd
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        # Use printf to strip any trailing newline
        subdir=$(printf "%s" "${out}")
        if [ -n "$subdir" ]; then
            __charm_debug "Listing directories in $subdir"
            __charm_handle_subdirs_in_dir_flag "$subdir"
        else
            __charm_debug "Listing directories in ."
            _filedir -d
        fi
    else
        while IFS='' read -r comp; do
            COMPREPLY+=("$comp")
        done < <(compgen -W "${out}" -- "$cur")
    fi
}

__charm_handle_reply()
{
    __charm_debug "${FUNCNAME[0]}"
    local comp
    case $cur in
        -*)
            if [[ $(type -t compopt) = "builtin" ]]; then
                compopt -o nospace
            fi
            local allflags
            if [ ${#must_have_one_flag[@]} -ne 0 ]; then
                allflags=("${must_have_one_flag[@]}")
            else
                allflags=("${flags[*]} ${two_word_flags[*]}")
            fi
            while IFS='' read -r comp; do
                COMPREPLY+=("$comp")
            done < <(compgen -W "${allflags[*]}" -- "$cur")
            if [[ $(type -t compopt) = "builtin" ]]; then
                [[ "${COMPREPLY[0]}" == *= ]] || compopt +o nospace
            fi

            # complete after --flag=abc
            if [[ $cur == *=* ]]; then
                if [[ $(type -t compopt) = "builtin" ]]; then
                    compopt +o nospace
                fi

                local index flag
                flag="${cur%=*}"
                __charm_index_of_word "${flag}" "${flags_with_completion[@]}"
                COMPREPLY=()
                if [[ ${index} -ge 0 ]]; then
                    PREFIX=""
                    cur="${cur#*=}"
                    ${flags_completion[${index}]}
                    if [ -n "${ZSH_VERSION:-}" ]; then
                        # zsh completion needs --flag= prefix
                        eval "COMPREPLY=( \"\${COMPREPLY[@]/#/${flag}=}\" )"
                    fi
                fi
            fi

            if [[ -z "${flag_parsing_disabled}" ]]; then
                # If flag parsing is enabled, we have completed the flags and can return.
                # If flag parsing is disabled, we may not know all (or any) of the flags, so we fallthrough
                # to possibly call handle_go_custom_completion.
                return 0;
            fi
            ;;
    esac

    # check if we are handling a flag with special work handling
    local index
    __charm_index_of_word "${prev}" "${flags_with_completion[@]}"
    if [[ ${index} -ge 0 ]]; then
        ${flags_completion[${index}]}
        return
    fi

    # we are parsing a flag and don't have a special handler, no completion
    if [[ ${cur} != "${words[cword]}" ]]; then
        return
    fi

    local completions
    completions=("${commands[@]}")
    if [[ ${#must_have_one_noun[@]} -ne 0 ]]; then
        completions+=("${must_have_one_noun[@]}")
    elif [[ -n "${has_completion_function}" ]]; then
        # if a go completion function is provided, defer to that function
        __charm_handle_go_custom_completion
    fi
    if [[ ${#must_have_one_flag[@]} -ne 0 ]]; then
        completions+=("${must_have_one_flag[@]}")
    fi
    while IFS='' read -r comp; do
        COMPREPLY+=("$comp")
    done < <(compgen -W "${completions[*]}" -- "$cur")

    if [[ ${#COMPREPLY[@]} -eq 0 && ${#noun_aliases[@]} -gt 0 && ${#must_have_one_noun[@]} -ne 0 ]]; then
        while IFS='' read -r comp; do
            COMPREPLY+=("$comp")
        done < <(compgen -W "${noun_aliases[*]}" -- "$cur")
    fi

    if [[ ${#COMPREPLY[@]} -eq 0 ]]; then
        if declare -F __charm_custom_func >/dev/null; then
            # try command name qualified custom func
            __charm_custom_func
        else
            # otherwise fall back to unqualified for compatibility
            declare -F __custom_func >/dev/null && __custom_func
        fi
    fi

    # available in bash-completion >= 2, not always present on macOS
    if declare -F __ltrim_colon_completions >/dev/null; then
        __ltrim_colon_completions "$cur"
    fi

    # If there is only 1 completion and it is a flag with an = it will be completed
    # but we don't want a space after the =
    if [[ "${#COMPREPLY[@]}" -eq "1" ]] && [[ $(type -t compopt) = "builtin" ]] && [[ "${COMPREPLY[0]}" == --*= ]]; then
       compopt -o nospace
    fi
}

# The arguments should be in the form "ext1|ext2|extn"
__charm_handle_filename_extension_flag()
{
    local ext="$1"
    _filedir "@(${ext})"
}

__charm_handle_subdirs_in_dir_flag()
{
    local dir="$1"
    pushd "${dir}" >/dev/null 2>&1 && _filedir -d && popd >/dev/null 2>&1 || return
}

__charm_handle_flag()
{
    __charm_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    # if a command required a flag, and we found it, unset must_have_one_flag()
    local flagname=${words[c]}
    local flagvalue=""
    # if the word contained an =
    if [[ ${words[c]} == *"="* ]]; then
        flagvalue=${flagname#*=} # take in as flagvalue after the =
        flagname=${flagname%=*} # strip everything after the =
        flagname="${flagname}=" # but put the = back
    fi
    __charm_debug "${FUNCNAME[0]}: looking for ${flagname}"
    if __charm_contains_word "${flagname}" "${must_have_one_flag[@]}"; then
        must_have_one_flag=()
    fi

    # if you set a flag which only applies to this command, don't show subcommands
    if __charm_contains_word "${flagname}" "${local_nonpersistent_flags[@]}"; then
      commands=()
    fi

    # keep flag value with flagname as flaghash
    # flaghash variable is an associative array which is only supported in bash > 3.
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        if [ -n "${flagvalue}" ] ; then
            flaghash[${flagname}]=${flagvalue}
        elif [ -n "${words[ $((c+1)) ]}" ] ; then
            flaghash[${flagname}]=${words[ $((c+1)) ]}
        else
            flaghash[${flagname}]="true" # pad "true" for bool flag
        fi
    fi

    # skip the argument to a two word flag
    if [[ ${words[c]} != *"="* ]] && __charm_contains_word "${words[c]}" "${two_word_flags[@]}"; then
        __charm_debug "${FUNCNAME[0]}: found a flag ${words[c]}, skip the next argument"
        c=$((c+1))
        # if we are looking for a flags value, don't show commands
        if [[ $c -eq $cword ]]; then
            commands=()
        fi
    fi

    c=$((c+1))

}

__charm_handle_noun()
{
    __charm_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    if __charm_contains_word "${words[c]}" "${must_have_one_noun[@]}"; then
        must_have_one_noun=()
    elif __charm_contains_word "${words[c]}" "${noun_aliases[@]}"; then
        must_have_one_noun=()
    fi

    nouns+=("${words[c]}")
    c=$((c+1))
}

__charm_handle_command()
{
    __charm_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    local next_command
    if [[ -n ${last_command} ]]; then
        next_command="_${last_command}_${words[c]//:/__}"
    else
        if [[ $c -eq 0 ]]; then
            next_command="_charm_root_command"
        else
            next_command="_${words[c]//:/__}"
        fi
    fi
    c=$((c+1))
    __charm_debug "${FUNCNAME[0]}: looking for ${next_command}"
    declare -F "$next_command" >/dev/null && $next_command
}

__charm_handle_word()
{
    if [[ $c -ge $cword ]]; then
        __charm_handle_reply
        return
    fi
    __charm_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"
    if [[ "${words[c]}" == -* ]]; then
        __charm_handle_flag
    elif __charm_contains_word "${words[c]}" "${commands[@]}"; then
        __charm_handle_command
    elif [[ $c -eq 0 ]]; then
        __charm_handle_command
    elif __charm_contains_word "${words[c]}" "${command_aliases[@]}"; then
        # aliashash variable is an associative array which is only supported in bash > 3.
        if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
            words[c]=${aliashash[${words[c]}]}
            __charm_handle_command
        else
            __charm_handle_noun
        fi
    else
        __charm_handle_noun
    fi
    __charm_handle_word
}

_charm_backup-keys()
{
    last_command="charm_backup-keys"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_completion()
{
    last_command="charm_completion"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")
    local_nonpersistent_flags+=("--help")
    local_nonpersistent_flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
    must_have_one_noun+=("bash")
    must_have_one_noun+=("fish")
    must_have_one_noun+=("powershell")
    must_have_one_noun+=("zsh")
    noun_aliases=()
}

_charm_crypt_decrypt()
{
    last_command="charm_crypt_decrypt"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_crypt_decrypt-lookup()
{
    last_command="charm_crypt_decrypt-lookup"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_crypt_encrypt()
{
    last_command="charm_crypt_encrypt"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_crypt_encrypt-lookup()
{
    last_command="charm_crypt_encrypt-lookup"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_crypt()
{
    last_command="charm_crypt"

    command_aliases=()

    commands=()
    commands+=("decrypt")
    commands+=("decrypt-lookup")
    commands+=("encrypt")
    commands+=("encrypt-lookup")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_fs_cat()
{
    last_command="charm_fs_cat"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_fs_cp()
{
    last_command="charm_fs_cp"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--recursive")
    flags+=("-r")
    local_nonpersistent_flags+=("--recursive")
    local_nonpersistent_flags+=("-r")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_fs_ls()
{
    last_command="charm_fs_ls"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_fs_mv()
{
    last_command="charm_fs_mv"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--recursive")
    flags+=("-r")
    local_nonpersistent_flags+=("--recursive")
    local_nonpersistent_flags+=("-r")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_fs_rm()
{
    last_command="charm_fs_rm"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_fs_tree()
{
    last_command="charm_fs_tree"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_fs()
{
    last_command="charm_fs"

    command_aliases=()

    commands=()
    commands+=("cat")
    commands+=("cp")
    commands+=("ls")
    commands+=("mv")
    commands+=("rm")
    commands+=("tree")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_help()
{
    last_command="charm_help"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_charm_id()
{
    last_command="charm_id"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_import-keys()
{
    last_command="charm_import-keys"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--force-overwrite")
    flags+=("-f")
    local_nonpersistent_flags+=("--force-overwrite")
    local_nonpersistent_flags+=("-f")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_jwt()
{
    last_command="charm_jwt"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_keys()
{
    last_command="charm_keys"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--randomart")
    flags+=("-r")
    local_nonpersistent_flags+=("--randomart")
    local_nonpersistent_flags+=("-r")
    flags+=("--simple")
    flags+=("-s")
    local_nonpersistent_flags+=("--simple")
    local_nonpersistent_flags+=("-s")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_kv_delete()
{
    last_command="charm_kv_delete"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_kv_get()
{
    last_command="charm_kv_get"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--show-binary")
    flags+=("-b")
    local_nonpersistent_flags+=("--show-binary")
    local_nonpersistent_flags+=("-b")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_kv_list()
{
    last_command="charm_kv_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--delimiter=")
    two_word_flags+=("--delimiter")
    two_word_flags+=("-d")
    local_nonpersistent_flags+=("--delimiter")
    local_nonpersistent_flags+=("--delimiter=")
    local_nonpersistent_flags+=("-d")
    flags+=("--keys-only")
    flags+=("-k")
    local_nonpersistent_flags+=("--keys-only")
    local_nonpersistent_flags+=("-k")
    flags+=("--reverse")
    flags+=("-r")
    local_nonpersistent_flags+=("--reverse")
    local_nonpersistent_flags+=("-r")
    flags+=("--show-binary")
    flags+=("-b")
    local_nonpersistent_flags+=("--show-binary")
    local_nonpersistent_flags+=("-b")
    flags+=("--values-only")
    flags+=("-v")
    local_nonpersistent_flags+=("--values-only")
    local_nonpersistent_flags+=("-v")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_kv_reset()
{
    last_command="charm_kv_reset"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_kv_set()
{
    last_command="charm_kv_set"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_kv_sync()
{
    last_command="charm_kv_sync"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_kv()
{
    last_command="charm_kv"

    command_aliases=()

    commands=()
    commands+=("delete")
    commands+=("get")
    commands+=("list")
    commands+=("reset")
    commands+=("set")
    commands+=("sync")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_link()
{
    last_command="charm_link"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_name()
{
    last_command="charm_name"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_serve()
{
    last_command="charm_serve"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--data-dir=")
    two_word_flags+=("--data-dir")
    local_nonpersistent_flags+=("--data-dir")
    local_nonpersistent_flags+=("--data-dir=")
    flags+=("--health-port=")
    two_word_flags+=("--health-port")
    local_nonpersistent_flags+=("--health-port")
    local_nonpersistent_flags+=("--health-port=")
    flags+=("--http-port=")
    two_word_flags+=("--http-port")
    local_nonpersistent_flags+=("--http-port")
    local_nonpersistent_flags+=("--http-port=")
    flags+=("--ssh-port=")
    two_word_flags+=("--ssh-port")
    local_nonpersistent_flags+=("--ssh-port")
    local_nonpersistent_flags+=("--ssh-port=")
    flags+=("--stats-port=")
    two_word_flags+=("--stats-port")
    local_nonpersistent_flags+=("--stats-port")
    local_nonpersistent_flags+=("--stats-port=")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_where()
{
    last_command="charm_where"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_charm_root_command()
{
    last_command="charm"

    command_aliases=()

    commands=()
    commands+=("backup-keys")
    commands+=("completion")
    commands+=("crypt")
    commands+=("fs")
    commands+=("help")
    commands+=("id")
    commands+=("import-keys")
    commands+=("jwt")
    commands+=("keys")
    commands+=("kv")
    commands+=("link")
    commands+=("name")
    commands+=("serve")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("server")
        aliashash["server"]="serve"
    fi
    commands+=("where")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()


    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

__start_charm()
{
    local cur prev words cword split
    declare -A flaghash 2>/dev/null || :
    declare -A aliashash 2>/dev/null || :
    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion -s || return
    else
        __charm_init_completion -n "=" || return
    fi

    local c=0
    local flag_parsing_disabled=
    local flags=()
    local two_word_flags=()
    local local_nonpersistent_flags=()
    local flags_with_completion=()
    local flags_completion=()
    local commands=("charm")
    local command_aliases=()
    local must_have_one_flag=()
    local must_have_one_noun=()
    local has_completion_function=""
    local last_command=""
    local nouns=()
    local noun_aliases=()

    __charm_handle_word
}

if [[ $(type -t compopt) = "builtin" ]]; then
    complete -o default -F __start_charm charm
else
    complete -o default -o nospace -F __start_charm charm
fi

# ex: ts=4 sw=4 et filetype=sh
