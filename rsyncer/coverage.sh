#!/bin/bash

dart run test --coverage coverage
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib
dart run remove_from_coverage:remove_from_coverage -f coverage/lcov.info
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html