# flow-test

A pod to unit-test a particular flow(not UI) based on method-names, to make sure that the corresponding methods are being ccalled.

## Why

When writing unit-tests for non-UI parts of an app, say like some kind of local in-memory store, I've found that basic unit-tests is not suitable for scenarios where there could be multiple ways of acheiving the same final result. So, although the unit-test passes, it may so happen that only one-route is being tested, while the other routes, which could also give the same result, are not. 

Ofcourse, this means that you are not treating your apis like a black-box. So, this should be useful particularly to the person implementing the flow and making sure that it does not break :) 

The point of this was to explicitly make sure that for a particular test, a certain list of methods need to be called, in a particular order, for it to be deemed successful, along with the assertions in the final state.

## TODO

- Everything :p
- Better documentation
- Swift support
- Assertions inside the arguments as well

## Author

gnithin, nithin.linkin@gmail.com

## License

flow-test is available under the MIT license. See the LICENSE file for more info.
