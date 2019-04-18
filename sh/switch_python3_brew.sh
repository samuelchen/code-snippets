#!/bin/sh                                                                                                               

# Script to switch brew installed Python 3 versions on MacOS
# by Samuel Chen <samuel.net@gmail.com>
  
# ref: https://stackoverflow.com/questions/51125013/how-can-i-install-a-previous-version-of-python-3-in-macos-using-homebrew/51125014#51125014

PY36_VER=`ls /usr/local/Cellar/python/ | grep 3.6`
PY37_VER=`ls /usr/local/Cellar/python/ | grep 3.7`

echo "===== Brew Python 3 ====="
echo "Active Python 3: \c"
python3 --version

echo ""
echo "1. List installed brew Python versions"
if [ -n "${PY37_VER}" ]; then
  echo "3. Switch to Python ${PY37_VER}"
fi
if [ -n "${PY36_VER}" ]; then
  echo "4. Switch to Python ${PY36_VER}"
fi
echo "7. Install latest Python 3"
echo "8. Install Python 3.6.5_1 (without sphinx-doc. ignore dependency)"
echo "9. Install python 3.6.5_1 (with sphinx-doc)"
echo "0. Quit (all other chars)"
echo "Please select:\c"
read n

if [[ $n == 1 ]]; then
  echo ">> Python 3 installed"
  brew info python | grep "/usr/local/Cellar/python"
elif [[ $n == 3 ]]; then
  echo ">> Switch to python 3.7.3"
  brew unlink python
  brew switch python 3.7.3
elif [[ $n == 4 ]]; then
  echo ">> Switch to python 3.6.5"
  brew unlink python
  brew switch python 3.6.5_1
elif [[ $n == 7 ]]; then
  echo ">> Install latest python 3"
  brew unlink python
  brew install python
  brew switch python 3.7.1
elif [[ $n == 8 ]]; then
    echo ">> Install python 3.6.5 without sphinx-doc (ignore dependency)"
  echo "   if you face sphinx-doc dependency issue, please check https://www.pyimagesearch.com/2019/01/30/macos-mojave-install-tensorflow-and-keras-for-deep-learning/ " 
  brew unlink python
  brew install --ignore-dependencies https://raw.githubusercontent.com/Homebrew/homebrew-core/f2a764ef944b1080be64bd88dca9a1d80130c558/Formula/python.rb
  brew switch python 3.6.5_1
elif [[ $n == 9 ]]; then
  echo ">> Install sphinx-doc and Python 3.6.5"
  brew install sphinx-doc
  brew unlink python
  brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/f2a764ef944b1080be64bd88dca9a1d80130c558/Formula/python.rb
  brew switch python 3.6.5_1
else
  echo ">> Quit <<"
fi

echo "Active: \c"
python3 --version

