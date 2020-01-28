# Changelog
All notable changes to this project will be documented in this file.

Please use the following tags when editing this file:
*Added* for new features.
*Changed* for changes in existing functionality.
*Deprecated* for soon-to-be removed features.
*Removed* for now removed features.
*Fixed* for any bug fixes. 

## [1.0.5] - 2020-01-15
### Added
- First release of domcmc as a separate package


## [2.0.0] - 2020-01-24
### Changed
- Now adheres to PEP8 for the naming of functions and keywords. 
  This change does break backward compatibility. Sorry for the bother but better now than 
  later I guess. 

## [2.0.1] - 2020-01-27
### Fixed
- Remove all temp files when interpolating onto pressure levels

## [2.0.2] - 2020-01-28
### Fixed
- Fixed bug where iunit was not closed when get_var was called with the mets_only option
