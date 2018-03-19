#!/usr/bin/env python
from __future__ import print_function
import os
import sys
import glob
from argparse import ArgumentParser


not_started_emoji = ':grey_question:'


def which(name):
    isexecutable = lambda f: os.path.exists(f) and os.access(f, os.X_OK)
    if isexecutable(name):
        return name
    for dirname in os.getenv('PATH').split(os.pathsep):
        filename = os.path.join(dirname, name)
        if isexecutable(filename):
            return filename
    raise Exception('Executable {0!r} not found!'.format(name))


def create_template(name, exnihilo_dir):

    # Template files to create
    tmp = '{0}.runme.f90'.format(name)
    dst = '{0}_runme.f90'.format(name)
    if os.path.isfile(dst):
        print('Test for {0} already exists!'.format(name))
        return

    # Corresponding Swig module file
    dirname = os.path.dirname(os.path.realpath(__file__))
    module = os.path.join(dirname, '..', '{0}.i'.format(name))
    if not os.path.isfile(module):
        print('Swig module for {0} does not exist!'.format(name))
        return

    # Make sure nemesis python path is set up
    if exnihilo_dir is None:
        f = which('template-gen')
        exnihilo_dir = os.path.join(os.path.dirname(f), '..', 'python')
    sys.path.insert(0, exnihilo_dir)
    import exnihiloenv.templategen as templategen

    templategen.main([tmp])
    os.rename(tmp, dst)

    return dst


def test_choices():
    """Determine possible tests by looking at roadmap.md.  This method is very
    fragile and fully dependent on roadmap.md being up to date"""
    dirname = os.path.dirname(os.path.realpath(__file__))
    pat = os.path.join(dirname, '..', '*.i')
    all_modules = [os.path.splitext(os.path.basename(_))[0] for _ in glob.glob(pat)]
    the_test_choices = []
    for line in open(os.path.join(dirname, 'roadmap.md')):
        line = [_.strip() for _ in line.split('|')]
        if line[0] != not_started_emoji:
            continue
        f = line[1][1:-1]
        if f in all_modules:
            the_test_choices.append(f)
    return the_test_choices


def main():
    p = ArgumentParser(usage='mktest.py [-h] [--exnihilo-dir=<DIRNAME>] <test>')
    p.add_argument('test', help='Name of test to generate',
                   choices=test_choices())
    p.add_argument('--exnihilo-dir')
    args = p.parse_args()

    # Find the right test
    f = create_template(args.test, args.exnihilo_dir)
    py_f = '../python/{0}.py'.format(os.path.splitext(f)[0])

    print('Test template {0!r} created'.format(f))
    print('The corresponding python test is in {0!r}'.format(py_f))


if __name__ == '__main__':
    main()
