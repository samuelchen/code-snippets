#!/bin/sh

# Script to switch brew installed Python 3 versions on MacOS
# by Samuel Chen <samuel.net@gmail.com>
  
# ref: https://stackoverflow.com/questions/51125013/how-can-i-install-a-previous-version-of-python-3-in-macos-using-homebrew/51125014#51125014

echo "===== Brew Python 3 ====="
echo "1. List installed python 3"
echo "3. Switch to Python 3.7.1"
echo "4. Switch to Python 3.6.5"
echo "8. Install latest python3"
echo "9. Install python 3.6.5"
echo "0. Quit (all other chars)"
echo "Please select:\c"
read n

if [[ $n == 1 ]]; then
  echo ">> Python 3 installed"
  brew info python | grep "/usr/local/Cellar/python"
elif [[ $n == 3 ]]; then
  echo ">> Switch to python 3.7.1"
  brew unlink python
  brew switch python 3.7.1
elif [[ $n == 4 ]]; then
  echo ">> Switch to python 3.6.5"
  brew unlink python
  brew switch python 3.6.5_1
elif [[ $n == 8 ]]; then
  echo ">> Install latest python 3"
  brew unlink python
  brew install python
elif [[ $n == 9 ]]; then
  echo ">> Install python 3.6.5"
  brew unlink python
  brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/f2a764ef944b1080be64bd88dca9a1d80130c558/Formula/python.rb
else
  echo ">> Quit <<"
fi

echo "Active: \c"
python3 --version
