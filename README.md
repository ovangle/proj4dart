# Proj4dart #

Dart bindings for the `proj4js` library.

## Usage ##

Include the proj4JS library in your application. The scripts are avaiable on the
[proj4 download page](https://github.com/proj4js/proj4js).

eg.

    <script src="lib/proj4.js"></script>
    
The module exports a single function `proj4`. Calling the function, with
the source and destination projection definitions (either the proj4 definition
or any of the named projections included in the proj4js library) will return
a `CoordinateTransform` function, which when passed a `Point` object from
the `dart:math` library, will transform it between the projections.