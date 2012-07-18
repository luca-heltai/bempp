#Copyright (C) 2011 by the BEM++ Authors
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

# This script downloads the third-party libraries required by BEM++


import sys,os
from py_modules.tools import writeOptions
from ConfigParser import ConfigParser
from optparse import OptionParser


import py_modules.boost as boost
import py_modules.armadillo as armadillo
import py_modules.tbb as tbb
import py_modules.dune as dune
import py_modules.trilinos as trilinos
import py_modules.bempp as bempp
import py_modules.ahmed as ahmed

###########################

# The following functions determine the directory in which the file resides.
# Trick taken from http://stackoverflow.com/questions/2632199/how-do-i-get-the-path-of-the-current-executed-file-in-python

def we_are_frozen():
    # All of the modules are built-in to the interpreter, e.g., by py2exe
    return hasattr(sys, "frozen")

def module_path():
    if we_are_frozen():
        return os.path.split(os.path.abspath(sys.executable))[0]
    return os.path.split(os.path.abspath(__file__))[0]

def configureAll(root,config):
    boost.configureBoost(root,config)
    dune.configureDune(root,config)
    tbb.configureTbb(root,config)
    armadillo.configureArmadillo(root,config)
    trilinos.configureTrilinos(root,config)
    ahmed.configureAhmed(root,config)
    bempp.configureBempp(root,config)

def buildAll(root,config):
    boost.buildBoost(root,config)
    dune.buildDune(root,config)
    tbb.buildTbb(root,config)
    armadillo.buildArmadillo(root,config)
    trilinos.buildTrilinos(root,config)
    ahmed.buildAhmed(root,config)
    bempp.buildBempp(root,config)

def prepare(root,config):
    # Test whether the main options are present
    if not config.has_option('Main','prefix'): raise Exception('prefix not defined')
    if not config.has_option('Main','cc'): raise Exception('cc not defined')
    if not config.has_option('Main','cxx'): raise Exception('cxx not defined')
    if not config.has_option('Main','root_dir'): config.set('Main','root_dir',root)
    if not config.has_option('Main','architecture'): config.set('Main','architecture','x64')
    if not config.has_option('Main','cflags'): config.set('Main','cflags',"")
    if not config.has_option('Main','cxxflags'): config.set('Main','cxxflags',"")

    prefix=config.get('Main','prefix')
    if not os.path.isdir(prefix+"/bempp"):
        os.mkdir(prefix+"/bempp")
        os.mkdir(prefix+"/bempp/contrib")
    if not os.path.isdir(root+"/contrib/files"):
        os.mkdir(root+"/contrib/files")

    # Add the correct architecture parameters
    cflags = config.get('Main','cflags')
    cxxflags = config.get('Main','cxxflags')

    arch = config.get('Main','architecture')
    if not arch in ['x64','i386']: raise Exception('Architecture not supported.')
    
    if sys.platform.startswith('darwin'):
        if arch=='x64':
            param = '-arch x86_64'
        else:
            param = '-arch i386'
        config.set('Main','cflags',cflags+" "+param)
        config.set('Main','cxxflags',cxxflags+" "+param)
    elif sys.platform.startswith('linux'):
       if arch=='x64':
            param = '-m64'
        else:
            param = '-m32'
        config.set('Main','cflags',cflags+" "+param)       
        config.set('Main','cxxflags',cxxflags+" "+param)
    else:
        raise Exception("Platform not supported")
    
###########################

if __name__ == "__main__":
 
    parser = OptionParser()
    parser.add_option("-c", "--configure", action="store_true", type="string", dest="configure", default=True)
    parser.add_option("-c", "--build", action="store_true", type="string", dest="build", default=True)
    (options,args) = parser.parse_args()
    root=module_path()
    config=ConfigParser()
    config.read(args[0])
    if options.configure:
        prepare(root,config)
        configureAll(root,config)
        writeOptions(root,config)
    if options.build:
        buildAll(root,config)


    
