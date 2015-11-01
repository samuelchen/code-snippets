#/bin/sh

# Replace python with pythonw when creating virtual env
# Used for wxPython or other apps which need to access GUI with Framework.

env=$1

if [ "$env" == "" ]; then
    echo "ERROR: you must specify virtualenv path name."
    exit 1
fi


virtualenv $env --system-site-packages $2 $3 $4 $5 $6 $7 $8 $9

if [ $# != 0 ]; then
    exit $#
fi

PYTHONW=/System/Library/Frameworks/Python.framework/Versions/Current/bin/pythonw
cd $env
venv=$PWD
cp $PYTHONW bin/
mv bin/python bin/python.bak
ln -s $venv/bin/pythonw bin/python
echo "export PYTHONHOME=$venv" >> bin/activate
cd -

