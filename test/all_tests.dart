library proj4dart.all_tests;

import 'dart:math' show Point;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

import '../lib/proj4.dart';

main() {
  useHtmlConfiguration();
  var srcProj = 'PROJCS["NAD83 / Massachusetts Mainland",GEOGCS["NAD83",DATUM["North_American_Datum_1983",SPHEROID["GRS 1980",6378137,298.257222101,AUTHORITY["EPSG","7019"]],AUTHORITY["EPSG","6269"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4269"]],UNIT["metre",1,AUTHORITY["EPSG","9001"]],PROJECTION["Lambert_Conformal_Conic_2SP"],PARAMETER["standard_parallel_1",42.68333333333333],PARAMETER["standard_parallel_2",41.71666666666667],PARAMETER["latitude_of_origin",41],PARAMETER["central_meridian",-71.5],PARAMETER["false_easting",200000],PARAMETER["false_northing",750000],AUTHORITY["EPSG","26986"],AXIS["X",EAST],AXIS["Y",NORTH]]';
  var destProj =  "+proj=gnom +lat_0=90 +lon_0=0 +x_0=6300000 +y_0=6300000 +ellps=WGS84 +datum=WGS84 +units=m +no_defs";

  test("calling a projection with two arguments creates a transformation from the source to the destination", () {
    var transform = proj4(srcProj, destProj);
    expect(transform(new Point(2,5)), new Point(-2690666.2977344487,3662659.885459919));
  });
  test("the result of calling the `inverse` method on the transform should reverse the transform", () {
    var transform = proj4(srcProj, destProj);
    var orig = transform.inverse(new Point(-2690666.2977344487,3662659.885459919));
    expect(orig.x, closeTo(2, 0.00000005));
    expect(orig.y, closeTo(5, 0.00000005));
  });
  test("calling transform with a single argument defaults to from WGS84", () {
    var transform = proj4(srcProj);
    expect(transform(new Point(-71,41)), new Point(242075.00535055372, 750123.32090043));
  });
}