#!/usr/bin/env python

# Copyright (c) 2020 Intel Corporation
#
# This work is licensed under the terms of the MIT license.
# For a copy, see <https://opensource.org/licenses/MIT>.

"""
This module provides a simple watchdog timer to detect timeouts
It is for example used in the ScenarioManager
"""
from __future__ import print_function

import threading

try:
    import thread
except ImportError:
    import _thread as thread


class Watchdog(object):
    """
    Simple watchdog timer to detect timeouts.

    Args:
        timeout (float): Timeout value of the watchdog [seconds]. If triggered, raises a KeyboardInterrupt.
    """

    def __init__(self, timeout=1.0):
        self._timeout = timeout
        self._timer = None
        self._failed = False
        self._watchdog_stopped = False

    def _callback(self):
        """Method called when the timer triggers. Raises a KeyboardInterrupt on the main thread."""
        print('Watchdog exception - Timeout of {} seconds occurred'.format(self._timeout))
        self._failed = True
        thread.interrupt_main()  # Interrupts the main thread

    def start(self):
        """Start the watchdog timer."""
        self.stop()  # Ensure any existing timer is stopped
        self._timer = threading.Timer(self._timeout, self._callback)
        self._timer.start()
        self._watchdog_stopped = False

    def stop(self):
        """Stop the watchdog timer."""
        if self._timer is not None:
            self._timer.cancel()
            self._timer = None
            self._watchdog_stopped = True

    def pause(self):
        """Pause the watchdog timer."""
        self.stop()

    def resume(self):
        """Resume the watchdog timer."""
        if self._watchdog_stopped:
            self.start()

    def update(self):
        """Reset the watchdog timer."""
        self.start()

    def get_status(self):
        """Return False if the watchdog exception occurred, True otherwise."""
        return not self._failed