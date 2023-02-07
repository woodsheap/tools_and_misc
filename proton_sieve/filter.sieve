# SPDX-FileCopyrightText: 2023 Brian Woods
# SPDX-License-Identifier: GPL-2.0-or-later

require "fileinto";

# anything directly to the users goes into the inbox
if header :contains ["To", "Cc", "Bcc"] "CHANGEME@protonmail.com" {
	stop;
}
# example of putting a list in directory
elsif header :contains ["List-Id"] "xen-devel.lists.xen.org" {
	fileinto "Folders/xen-devel" ;
	stop ;
}

