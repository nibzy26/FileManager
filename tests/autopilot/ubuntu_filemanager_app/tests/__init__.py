# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
# Copyright 2013 Canonical
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.

"""Filemanager app autopilot tests."""

import os.path
import shutil
import tempfile
import logging

from autopilot.input import Mouse, Touch, Pointer
from autopilot.platform import model
from autopilot.testcase import AutopilotTestCase
from ubuntu_filemanager_app import emulators
from ubuntuuitoolkit import (
    base,
    emulators as toolkit_emulators
)

logger = logging.getLogger(__name__)


class FileManagerTestCase(AutopilotTestCase):

    """A common test case class that provides several useful methods for
    filemanager-app tests.

    """
    if model() == 'Desktop':
        scenarios = [('with mouse', dict(input_device_class=Mouse))]
    else:
        scenarios = [('with touch', dict(input_device_class=Touch))]

    local_location = "../../ubuntu-filemanager-app.qml"
    installed_location = "/usr/share/ubuntu-filemanager-app/" \
                         "ubuntu-filemanager-app.qml"

    def setup_environment(self):
        if os.path.exists(self.local_location):
            logger.debug("Running via local installation")
            launch = self.launch_test_local
            test_type = 'local'
        elif os.path.exists(self.installed_location):
            logger.debug("Running via installed debian package")
            launch = self.launch_test_installed
            test_type = 'deb'
        else:
            logger.debug("Running via click package")
            launch = self.launch_test_click
            test_type = 'click'
        return launch, test_type

    def setUp(self):
        launch, self.test_type = self.setup_environment()
        self._create_test_root()
        self.pointing_device = Pointer(self.input_device_class.create())
        super(FileManagerTestCase, self).setUp()
        #turn off the OSK so it doesn't block screen elements
        if model() != 'Desktop':
            os.system("stop maliit-server")
            #adding cleanup step seems to restart service immeadiately
            #disabling for now
            #self.addCleanup(os.system("start maliit-server"))

        self.original_file_count = \
            len([i for i in os.listdir(os.environ['TESTHOME'])
                 if not i.startswith('.')])
        logger.debug("Directory Listing for TESTHOME\n%s" %
                     os.listdir(os.environ['TESTHOME']))
        logger.debug("File count in TESTHOME is %s" % self.original_file_count)
        launch()

    def _create_test_root(self):
        #create a temporary directory for testing purposes
        #due to security lockdowns, make it under /home always
        temp_dir = tempfile.mkdtemp(dir=os.path.expanduser("~"))
        self.addCleanup(shutil.rmtree, temp_dir)
        logger.debug("Created root test directory " + temp_dir)
        self.patch_environment('TESTHOME', temp_dir)
        logger.debug("Patched root test directory " + temp_dir)
        return temp_dir

    def launch_test_local(self):
        self.app = self.launch_test_application(
            base.get_qmlscene_launch_command(),
            self.local_location,
            app_type='qt',
            emulator_base=toolkit_emulators.UbuntuUIToolkitEmulatorBase)

    def launch_test_installed(self):
        self.app = self.launch_test_application(
            base.get_qmlscene_launch_command(),
            self.installed_location,
            "--desktop_file_hint="
            "/usr/share/applications/ubuntu-filemanager-app.desktop",
            app_type='qt',
            emulator_base=toolkit_emulators.UbuntuUIToolkitEmulatorBase)

    def launch_test_click(self):
        self.app = self.launch_click_package(
            "com.ubuntu.filemanager",
            emulator_base=toolkit_emulators.UbuntuUIToolkitEmulatorBase)

    @property
    def main_view(self):
        return self.app.select_single(emulators.MainView)
