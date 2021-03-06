// Copyright (C) 2011-2012 by the BEM++ Authors
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#ifndef SpaceIdentifier_hpp
#define SpaceIdentifier_hpp

enum SpaceIdentifier {
  PIECEWISE_CONSTANT_SCALAR,
  PIECEWISE_CONSTANT_SCALAR_BARYCENTRIC,
  PIECEWISE_CONSTANT_DISCONTINUOUS_SCALAR_BARYCENTRIC,
  PIECEWISE_CONSTANT_DUAL_GRID_SCALAR,
  PIECEWISE_CONSTANT_DUAL_GRID_DISCONTINUOUS_SCALAR,
  PIECEWISE_LINEAR_CONTINUOUS_SCALAR,
  PIECEWISE_LINEAR_CONTINUOUS_SCALAR_BARYCENTRIC,
  PIECEWISE_LINEAR_DISCONTINUOUS_SCALAR,
  PIECEWISE_LINEAR_DISCONTINUOUS_SCALAR_BARYCENTRIC,
  PIECEWISE_POLYNOMIAL_CONTINUOUS_SCALAR,
  PIECEWISE_POLYNOMIAL_DISCONTINUOUS_SCALAR,
  RAVIART_THOMAS_0_VECTOR,
  UNIT_SCALAR
};

#endif
