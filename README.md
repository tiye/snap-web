## Travis CI

- [![Master](https://secure.travis-ci.org/HaskellCNOrg/a.haskellcn.png?branch=master)](http://travis-ci.org/HaskellCNOrg/a.haskellcn)

## Features
### 0.1
 - User Registration
 - Add/Update New Posts
 - Add Comment to either a Topic or Comment
 - Pagination for Posts

## Installation

*Assume OS is \*inux with make otherwise figure out yourself by reading Makefile*

0. Install MongoDB

1. Install Snaplet-Environments

*Need to be in this way because the one in Hackage is not compatibale with snap-0.8*

    git clone git://github.com/HaskellCNOrg/Snaplet-Environments.git
    cd Snaplet-Environments
    make install

2. Install a.haskell.cn

    git clone git://github.com/HaskellCNOrg/a.haskellcn.git

3. Env Config (which has config that not going to be shared)
   
    cp data/env.cfg.default data/env.cfg   
    
4. (Optional) Other customization files

- `data/main.cfg`
- `data/message-*.cfg`

## License

Check the LICENSE file

## Contribute

Feel free ask questiones and contribute.


