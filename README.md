[![license-badge](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io/badge/license-MIT-blue.svg)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

# Table of Contents

- [Description](#description)
- [Installation](#installation)
  - [Baseline String](#baseline-string)
- [Implementation notes](#implementation-note)
- [Contribute](#contribute)
  - [Version management](#version-management)
- [License](#license)

# Description

This package introduces a call graph visualization to help you analyze and understand the flow of method calls within your codebase. The idea is to quickly view method sends to uncover dependencies and relationships with ease. You can also easily distinguish between different types of methods sends with color-coded nodes. This visual cue aids in quickly identifying key 
methods and understanding their roles in the overall system.

# Installation

It works currently in Pharo 12:

```smalltalk
EpMonitor disableDuring: [ 
	Metacello new	
		baseline: 'CallGraphViz';	
		repository: 'github://hernanmd/CallGraphViz/src';	
		load ].
```

## Baseline String 

If you want to add the CallGraphViz to your Metacello Baselines or Configurations, copy and paste the following expression:
```smalltalk
	" ... "
	spec
		baseline: 'CallGraphViz' 
		with: [ spec repository: 'github://hernanmd/CallGraphViz/src' ];
	" ... "
```

# Usage

To access the GraphViz object:

```smalltalk
CallGraphViz callGraphOfMethod: (String >> #alike:).
```

You can then export it in SVG format:

```smalltalk
(CallGraphViz callGraphOfMethod: (String >> #alike:)) exportToSVG.
```

To open a window with the call graph:

```smalltalk
CallGraphViz openCallGraphOfMethod:: (String >> #alike:)
```

# Screenshots

## A small call graph

```smalltalk
CallGraphViz openCallGraphOfMethod:: (String >> #alike:)
```

![String-alike](https://github.com/hernanmd/CallGraphViz/assets/4825959/d0f732fe-ad20-4faa-9ebf-5410e4a10474)

## A big call graph

```smalltalk
CallGraphViz callGraphOfMethod: (MonitorDelay>> #setDelay:forSemaphore:monitor:queue:).
```

![callGraphOfsetDelayforSemaphoremonitorqueue](https://github.com/hernanmd/CallGraphViz/assets/4825959/8cd25b62-cd73-442d-9da2-183c10ffa5fc)


# Contribute

**Working on your first Pull Request?** You can learn how from this *free* series [How to Contribute to an Open Source Project on GitHub](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github)

If you have discovered a bug or have a feature suggestion, feel free to create an issue on Github.
If you have any suggestions for how this package could be improved, please get in touch or suggest an improvement using the GitHub issues page.
If you'd like to make some changes yourself, see the following:    

  - Fork this repository to your own GitHub account and then clone it to your local device
  - Do some modifications
  - Test.
  - Add <your GitHub username> to add yourself as author below.
  - Finally, submit a pull request with your changes!
  - This project follows the [all-contributors specification](https://github.com/kentcdodds/all-contributors). Contributions of any kind are welcome!

## Version management 

This project use semantic versioning to define the releases. This means that each stable release of the project will be assigned a version number of the form `vX.Y.Z`. 

- **X** defines the major version number
- **Y** defines the minor version number 
- **Z** defines the patch version number

When a release contains only bug fixes, the patch number increases. When the release contains new features that are backward compatible, the minor version increases. When the release contains breaking changes, the major version increases. 

Thus, it should be safe to depend on a fixed major version and moving minor version of this project.

# License
	
This software is licensed under the MIT License.

Copyright Hernán Morales Durand, 2022.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Authors

Hernán Morales Durand
