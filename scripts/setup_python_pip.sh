# Install pip3 for Python 3
sudo apt-get install python3-pip

# Install pip packages
declare -a packages=("important" "bestbuy" "pyualtrics" "twine" "Robinhood" "robin-stocks" "python-dotenv" "pyspark" "pyperclip" "pycrypto" "notifiers" "nltk" "lxml" "louis" "gpg" "GitPython" "geopy" "findspark" "future" "dropbox" "discord.py" "cryptography" "boto3" "colorama" "praw" "prawcore" "pysqlcipher3" "segno" "textblob" "tweepy" "GGA" "docutils" "python-dateutil" "six" "setuptools" "beautifulsoup4" "opencv-python" "Pillow" "discord" "plexapi" "requests" "asyncio" "zxcvbn" "numpy" "scipy" "pandas")
for val in ${packages[@]}; do
  echo Installing $val
  sudo pip3 install $val
done