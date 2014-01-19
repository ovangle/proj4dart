//Copyright (c) 2014 Thomas Stephenson <ovangle@gmail.com>

library proj4dart;

import 'dart:math' as math show Point;
import 'dart:js' as js;
import 'package:js_wrapping/js_wrapping.dart';

_jsify(arg) => new js.JsObject.jsify(arg);
/**
 * Create a new [CoordinateTransformer] from the source projection
 * to the destination projection.
 *
 * If [:src:] is not provided, then the transformation will be
 * assumed to be between the `WGS84` datum and the target projection
 *
 * eg.
 *      forward = transformer('PROJCS["NAD83 / Massachusetts Mainland",GEOGCS["NAD83",DATUM["North_American_Datum_1983",SPHEROID["GRS 1980",6378137,298.257222101,AUTHORITY["EPSG","7019"]],AUTHORITY["EPSG","6269"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4269"]],UNIT["metre",1,AUTHORITY["EPSG","9001"]],PROJECTION["Lambert_Conformal_Conic_2SP"],PARAMETER["standard_parallel_1",42.68333333333333],PARAMETER["standard_parallel_2",41.71666666666667],PARAMETER["latitude_of_origin",41],PARAMETER["central_meridian",-71.5],PARAMETER["false_easting",200000],PARAMETER["false_northing",750000],AUTHORITY["EPSG","26986"],AXIS["X",EAST],AXIS["Y",NORTH]]';
 *                           , "+proj=gnom +lat_0=90 +lon_0=0 +x_0=6300000 +y_0=6300000 +ellps=WGS84 +datum=WGS84 +units=m +no_defs");
 *      print(forward(new Point(2,5)))
 *
 * will print `Point(-2690666.2977344505, 3662659.885459918)`
 *
 * To obtain the inverse transformation, returned [CoordinateTransformer]s
 * have an `inverse` method, which when called on a [math.Point] object
 * will reverse the transformation.
 */
CoordinateTransformer proj4(String src_or_dest, [String dest]) =>
    new CoordinateTransformer(src_or_dest, dest);


class CoordinateTransformer extends TypedJsObject implements Function {
  /**
   * The source projection of the transform which was used to create
   * this [CoordinateTransformer] object
   */
  final String srcProjection;
  /**
   * The destination projection of the transform which was used to create
   * this [CoordinateTransformer] object.
   * Throws an [ArgumentError] if the definition is not recognised by
   * the proj4 library.
   */
  final String destProjection;
  CoordinateTransformer._(this.srcProjection, this.destProjection, js.JsObject proj) :
    super.fromJsObject(proj);

  factory CoordinateTransformer(String src_or_dest, [String dest]) {
    var projection;
    if (dest == null) {
      projection = js.context.callMethod('proj4', [src_or_dest]);
      dest = src_or_dest;
      src_or_dest = 'WGS84';
    } else {
      projection = js.context['proj4'].apply([src_or_dest, dest]);
    }
    return new CoordinateTransformer._(src_or_dest, dest, projection);
  }

  math.Point call(math.Point p) {
      var result = $unsafe.callMethod('forward', [_jsify([p.x, p.y])]);
      return new math.Point(result[0], result[1]);
  }

  /**
   * Performs the forward tansformation on the [:math.Point:] p
   */
  math.Point forward(math.Point p) => this(p);

  /**
   * Performs the inverse transformation on the [math.Point] p
   */
  math.Point inverse(math.Point p) {
    var result = $unsafe.callMethod('inverse', [_jsify([p.x, p.y])]);
    return new math.Point<num>(result[0], result[1]);
  }
}