# Changelog
All notable changes to this project will be documented in this file.

Please use the following tags when editing this file:
*Added* for new features.
*Changed* for changes in existing functionality.
*Deprecated* for soon-to-be removed features.
*Removed* for now removed features.
*Fixed* for any bug fixes. 

## [2.1.3] - 2023-10-25
### Changed
- New rpnpy dependencies, fixes bug preventing pressure computation with SLEEVE levels. 

## [2.1.2] - 2023-03-24
### Added
- Added combined yin yang grid descriptors in output

## [2.1.1] - 2022-07-06
### Changed
- update dependencies for rpnpy

## [2.1.0] - 2021-06-12
### Changed
- Use 2.1 an greater for use on U2 (ppp5 and ppp6)
### Added
- Support for different vertical interpolation types
- support for python 3.7-3.10

## [2.0.11] - 2021-08-31
### Changed
- last version that works on U1 (ppp3 and ppp4)
### Added
- Conda install now supporting Python 3.8
### Changed
- fst_tools now check date returned by rmnlib functions to prevent bug where entries 
  closer than 1 minute all get returned even in is it does not match with cmc_timestamp
- New SSM packages are loaded to fix rpnpy bug with numpy >= 1.20

## [2.0.10] - 2020-11-13
### Added
- now able to get zonal and meridional wind from UU and VV
- A new illustrated example that also acts as validation of the wind rotation
### Changed
- examples now separated from the code for easier navigation in the documentation
### Fixed
- bug preventing 3D outputs on the Yin-Yang grid

## [2.0.9] - 2020-10-23
### Fixed
- pressure interpolation now functionnal with automatic file finding in a directory for a given date

## [2.0.8] - 2020-05-27
### Added
- Now loading necessary SSM (rpnPy, vgrid, d.pxs2pxt, etc.) during environment activation

## [2.0.7] - 2020-05-15
### Added
- added RPNpy dependencies so that domcmc can work from a straight install

## [2.0.6] - 2020-05-14
### Fixed
- Same syntax for dependencies as for domutils. Hopefully this will solve the dependency problem

## [2.0.5] - 2020-05-14
### Added
- Very loose numpy and python versions for easier install

## [2.0.4] - 2020-05-14
### Fixed
- Fixed numpy and python versions to fix a dependency problem

## [2.0.3] - 2020-03-11
### Added
- Added support for Yin-Yang grids. New "Yin" and "Yang" grids appear in the output dictionary when 
they are detected. Defaut "values", meta and lat/lon point to those of the Yin grid.

## [2.0.2] - 2020-01-28
### Fixed
- Fixed bug where iunit was not closed when get_var was called with the mets_only option

## [2.0.1] - 2020-01-27
### Fixed
- Remove all temp files when interpolating onto pressure levels

## [2.0.0] - 2020-01-24
### Changed
- Now adheres to PEP8 for the naming of functions and keywords. 
  This change does break backward compatibility. Sorry for the bother but better now than 
  later I guess. 

## [1.0.5] - 2020-01-15
### Added
- First release of domcmc as a separate package
