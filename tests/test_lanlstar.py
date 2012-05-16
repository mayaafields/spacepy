#!/usr/bin/env python2.6
# -*- coding: utf-8 -*-

"""
test the LANLstar module

Copyright 2011 Los Alamos National Security, LLC.
"""

import unittest
import spacepy.LANLstar as sl
import numpy
from numpy import array

class lanlstarTest(unittest.TestCase):

    def setUp(self):
        self.dat = {
            'Kp'     : array([2.7    ]),
            'Dst'    : array([7.7777 ]),
            'dens'   : array([4.1011 ]),
            'velo'   : array([400.101]),
            'Pdyn'   : array([4.1011 ]),
            'ByIMF'  : array([3.7244 ]),
            'BzIMF'  : array([-0.1266]),
            'G1'     : array([1.02966]),
            'G2'     : array([0.54933]),
            'G3'     : array([0.81399]),
            'W1'     : array([0.12244]),
            'W2'     : array([0.2514 ]),
            'W3'     : array([0.0892 ]),
            'W4'     : array([0.0478 ]),
            'W5'     : array([0.2258 ]),
            'W6'     : array([1.0461 ]),
            'Year'   : array([1996   ]),
            'DOY'    : array([6      ]),
            'Hr'     : array([1.2444 ]),
            'Lm'     : array([4.9360 ]),
            'Bmirr'  : array([315.620]),
            'rGSM'   : array([4.8341 ]),
            'lonGSM' : array([-40.266]),
            'latGSM' : array([36.4469]),
            'PA'     : array([57.3875])}
                                                                                
    def test_get_lanlstar(self):
        expected_lstar = {'OPDyn'   : array([4.7171]),
                          'OPQuiet' : array([4.6673]),
                          'T01QUIET': array([4.8427]),
                          'T01STORM': array([4.8669]),
                          'T89'     : array([4.5187]),
                          'T96'     : array([4.6439]),
                          'T05'    : array([4.7174])}

        Bmodels = ['OPDyn','OPQuiet','T01QUIET','T01STORM','T89','T96','T05']
        actual = sl.LANLstar(self.dat, Bmodels)
        for key in Bmodels:
            numpy.testing.assert_almost_equal(expected_lstar[key], actual[key], decimal=4)

    def test_get_lanlmax(self):
        expected_lmax = {'OPDyn'   : array([10.6278]),
                          'OPQuiet' : array([9.3352]),
                          'T01QUIET': array([10.0538]),
                          'T01STORM': array([9.9300]),
                          'T89'     : array([8.2888]),
                          'T96'     : array([9.2410]),
                          'T05'    : array([9.9295])}

        Bmodels = ['OPDyn','OPQuiet','T01QUIET','T01STORM','T89','T96','T05']
        actual = sl.LANLmax(self.dat, Bmodels)
        for key in Bmodels:
            numpy.testing.assert_almost_equal(expected_lmax[key], actual[key], decimal=4)
            

if __name__=="__main__":
    unittest.main()