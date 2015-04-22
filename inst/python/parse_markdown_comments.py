#!/usr/bin/env python3
"""
#% markdown comments for various source files
#%
#% extract markdown like comments from (source code) file, convert them to
#% valid markdown and run pandoc on it.
#% Since the comment characters for different languagues change, this program
#% can be adjusted to use the comment character used in your file by command
#% line arguments.
#%
#% author: Dominik Cullmann  
#% copyright: 2014, Dominik Cullmann  
#% license: GPL v3.0  
#% version: 0.1-2  
#% maintainer: Dominik cullmann  
#% email: dominik.cullmann@forst.bwl.de  
#% status: prototype  
"""

#% import modules
import re
import subprocess
import argparse
import textwrap
import os
import sys


def is_tool(name):
    """
    test if a program is installed
    """
    try:
        devnull = open(os.devnull)
        subprocess.Popen([name, '-h'], stdout=devnull,
                stderr=devnull).communicate()
    except OSError:
        print('please install ' + name)
        if name == 'pandoc' and os.name != 'posix':
            print("you may try\n" + "install.packages('installr'); " +
                    "library('installr'); install.pandoc()\n" + "in GNU R"
                    )
        raise
    return True


class CustomFormatter(argparse.ArgumentDefaultsHelpFormatter,
        argparse.RawDescriptionHelpFormatter):
    """
    just a CustomFormatter
    """
    pass


def make_parser():
    """
    use a parser function to add argparse help to docstring
    taken from http://stackoverflow.com/questions/22793577/
    display-argparse-help-within-pydoc
    """

    parser = argparse.ArgumentParser(
            formatter_class=CustomFormatter,
            description='convert markdown-style from a file to markdown ' +
            'and html via pandoc.',
            epilog=textwrap.dedent('''\
markdown style comments are headed by one or more comment characters giving
the markdown heading level and a magic character marking it as
markdown.
try --example for an example
            ''')
            )
    parser.add_argument('file_name', metavar='file',
            help='the name of the file to convert comments from'
            )
    parser.add_argument('-o', '--postfix',  dest='name_postfix',
            default='_markdown',
            help='change the postfix added to the files created'
            )
    parser.add_argument('-e', '--prefix',  dest='name_prefix',
            default='',
            help='change the prefix added to the files created'
            )
    parser.add_argument('-c', '--comment',  dest='comment_character',
            default='#',
            help='change the comment character'
            )
    parser.add_argument('-m', '--magic',  dest='magic_character',
            default='%',
            help='change the magic character'
            )
    parser.add_argument('--example', action='version',
    version=('''A typical markdown-style comment in a python source code
    file would look like
##% *This* is an example markdown comment of heading level 2
for a ## markdown comment.
#######% **This** is an example of a markdown paragraph: markdown recognizes
#######% only six levels of heading, so we use seven levels to mark
#######% "normal" text.
#######% Here you can use the full
#######% [markdown syntax](http://daringfireball.net/projects/markdown/syntax).
#######% *Note* the trailing line: markdown needs an empty line to end a
#######% paragraph.
#######%
''')
            )
    parser.add_argument('-p', '--header-pattern',  dest='header_pattern',
            default='^$',
            help='give the regex pattern to find the line determining a ' +
            'header. If you give an empty string, any header will be parsed' +
            'as if it were a markdown-style comment.'
            )
    parser.add_argument('-l', '--latex', dest='compile_latex',
            action='store_true')
    return parser


def extract_matching_lines(file_name, header_pattern, comment_character,
        magic_character):
    """
    extract a potential file header and all starting with a combination of
    comment_character and magic_character.
    """
    #% setup the markdown markup...
    markdown_regex = re.compile('\s*' + comment_character + '+' +
            magic_character)
    header_regex = re.compile(header_pattern)
    #% read the file into an arrays
    infile = open(file_name, 'r')
    body = []
    if len(header_pattern) > 0:
        #% read header
        header = []
        for line in infile:
            header.append(line)
            if header_regex.match(line):
                break
        title = []
        for line in header:
            title.append(line)
            # if magic_character is blank, comment_character and
            # newline will do as header_pattern.
            if re.match('\s*' + comment_character + '+' +
                    magic_character + '\s*$', line) or \
                            magic_character == ' ' and \
                            re.match('\s*' + comment_character + '+' '\s*$',
                                    line):
                break
        # title consists of several lines (an optional shebang, a title and the
        # comment newline), we pick the second last as _the_ title line
        title = (title[-2])
        # make sure the title is a header of level 1
        title = re.sub('^\s*' + comment_character + '*',
                       comment_character, title
                       )
        is_description = False
        description = []
        for line in header:
            if re.match('\s*' + comment_character + '+' +
                    magic_character + '\s*$', line):
                is_description = True
            if is_description:
                # make sure the description is heading level 7 which will be
                # converted to text later.
                line = re.sub('^\s*' + comment_character + '*',
                   ''.join(comment_character * 7), line
                   )
                description.append(line)
        # add an extra line to description to end the markdown paragraph
        body.append(title)
        body.extend(description)
        body.append(''.join(comment_character * 7) + magic_character)
    #% read body
    for line in infile:
        body.append(line)
    matching_lines = []
    for line in body:
        ##% only keep lines matching markdown markup
        if markdown_regex.match(line):
            matching_lines.append(line)
    infile.close()
    return(matching_lines)


def convert_lines_to_markdown(lines, comment_character, magic_character):
    """
    convert matching lines to markdown
    """
    converted_lines = []
    for line in lines:
        line = line.lstrip()
        ###% remove 7 heading levels
        line = re.sub(''.join(comment_character * 7), '', line)
        line = line.replace(comment_character, '#')
        if magic_character != '':
            line = line.replace(magic_character, ' ')
        #######% empty lines (ending markdown paragraphs) are not written by
        #######% file.write(), so we replace them by newlines.
        #######%
        if line == ' ' or line == '':
            line = '\n'
        #line  = line + '\n'
        converted_lines.append(line)
    return(converted_lines)

_parser = make_parser()
__doc__ += _parser.format_help()


if __name__ == '__main__':
    #% parse command line arguments
    args = _parser.parse_args()
    lines_matched = extract_matching_lines(args.file_name, args.header_pattern,
            args.comment_character, args.magic_character)
    markdown_lines = convert_lines_to_markdown(lines_matched,
            args.comment_character, args.magic_character)
    if all(line == '\n' for line in markdown_lines):
        sys.exit(2)
    #% write md file
    base_name = os.path.basename(args.file_name)
    full_base_name = args.name_prefix + base_name + args.name_postfix
    md_file_name = full_base_name + '.md'
    md_file = open(md_file_name, 'w')
    for markdown_line in markdown_lines:
        md_file.write(markdown_line)
    md_file.close()
    #% run pandoc
    if is_tool('pandoc'):
        subprocess.call(['pandoc',  md_file_name, '-o', full_base_name +
            '.html'])
        subprocess.call(['pandoc',  md_file_name, '-o', full_base_name +
            '.pdf'])
        subprocess.call(['pandoc',  md_file_name, '-o', 'tmp_' +
            full_base_name + '.tex'])
        #% prepare texfile from pandoc
        tex_file_name = full_base_name + '.tex'
        out_file = open(tex_file_name, 'w')
        out_file.write('\documentclass[twoside]{article}\n' +
                '\\usepackage{hyperref}\n\n\\begin{document}')
        in_file = open('tmp_' + full_base_name + '.tex', 'r')
        for in_line in in_file:
            out_file.write(in_line)
        in_file.close()
        out_file.write('\\end{document}\n')
        out_file.close()
        os.remove('tmp_' + full_base_name + '.tex')
        if args.compile_latex:
            #% If on posix...
            if os.name == 'posix':
                ##% ... tex it
                if is_tool('texi2pdf'):
                    subprocess.call(['texi2pdf', '--batch', '--clean',
                        tex_file_name])
            else:
                ##% ... warn otherwise
                print("you're not running posix, see how to compile\n" +
                        tex_file_name +
                        "\nconsulting your operating system's documentation.")
    sys.exit(0)
