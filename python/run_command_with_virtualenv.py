    # call a comand with py virtualenv via popen
    # Not work well now. need tuning.
    
    def run_command_with_virtualenv(venv_path, commands, output, stop_event):
        environment = os.environ.copy()
        # environment['PATH'] = os.pathsep.join([bin_path, environment['PATH']])
        #
        # subprocess.check_call("pip install -r dev_requirements.txt", env=environment)

        cwd = os.getcwd()
        pwd = os.path.abspath(os.path.sep.join([os.path.dirname(os.path.abspath(__file__)), '..', '']))
        print('change to:', pwd)

        virtualenv = venv_path
        venv = ''
        if virtualenv:
            sb = [virtualenv, sys.platform.startswith('win') and 'scripts' or 'bin', 'activate_this.py']
            venv = os.path.abspath(os.path.sep.join(sb))

        if sys.platform.startswith('win'):
            line_break = '\r\n'
            tmp = tempfile.NamedTemporaryFile(suffix='.bat', mode='w+t', delete=False)
            tmp.writelines(['@echo off', line_break])
            exe = None
        else:
            # if virtualenv:
            #     sb = [virtualenv, 'bin', 'activate']
            #     venv = os.path.abspath(os.path.sep.join(sb))
            #     venv = 'bin ' + venv
            line_break = '\n'
            tmp = tempfile.NamedTemporaryFile(suffix='.sh', mode='w+t', delete=False)
            tmp.writelines(['#!/bin/sh', line_break])
            exe = '/bin/sh'

        cmd = ' '.join(commands)
        print(tmp.name)
        print(venv)
        print(cmd)
        if virtualenv:
            tmp.writelines([venv, line_break])
        tmp.writelines(['cd', ' ', pwd, line_break])
        tmp.writelines([cmd, line_break])
        tmp.close()

        arguments = [tmp.name, ]
        p = subprocess.Popen(arguments, executable=exe, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                             stdin=subprocess.PIPE, env=environment, universal_newlines=True)

        print('1111')
        # (x, y) = p.communicate()
        # msg = '%s \r\n<br/>\r\n %s' % (x.decode(), y.decode())
        # print(msg)
        p.stdin.close()

        while True:
            if stop_event.is_set():
                p.stdout.close()
                break

            out = p.stdout.read(1)
            if out == '' and p.poll() is not None:
                break
            if out != '':
                output.write(out)
            else:
                sleep(0.1)
        print(p.returncode)
