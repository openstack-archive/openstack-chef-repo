#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Configuration file for the Sphinx documentation builder.
#
# This file does only contain a selection of the most common options. For a
# full list see the documentation:
# http://www.sphinx-doc.org/en/stable/config.html

# -- Path setup --------------------------------------------------------------

import imp
import os
import re
import sys

import openstackdocstheme

# -- Chef OpenStack configuration --------------------------------------------
target_name = 'chef-openstack-docs'
description = 'Chef OpenStack uses Chef to deploy OpenStack environments.'
previous_series_name = 'pike'
current_series_name = 'queens'

# -- Project information -----------------------------------------------------

title = u'Chef OpenStack Documentation'
category = 'Miscellaneous'
copyright = u'2014-2018, Chef OpenStack Contributors'
author = u'Chef OpenStack Contributors'

current_series = openstackdocstheme.ext._get_series_name()

if current_series == "latest":
  watermark = "Pre-release"
  latest_tag = "master"
  branch = "master"
  upgrade_warning = "Upgrading to master is not recommended. Master is under heavy development, and is not stable."
else:
  watermark = series_names = current_series.capitalize()
  latest_tag = os.popen('git describe --abbrev=0 --tags').read().strip('\n')
  branch = "stable/{}".format(current_series)
  upgrade_warning = "The upgrade is always under active development."

# Substitutions loader
rst_epilog = """
.. |current_release_git_branch_name| replace:: {current_release_git_branch_name}
.. |previous_release_formal_name| replace:: {previous_release_formal_name}
.. |current_release_formal_name| replace:: {current_release_formal_name}
.. |latest_tag| replace:: {latest_tag}
.. |upgrade_warning| replace:: {upgrade_warning}
""".format(
  current_release_git_branch_name=branch,
  previous_release_formal_name=previous_series_name.capitalize(),
  current_release_formal_name=current_series_name.capitalize(),
  latest_tag=latest_tag,
  upgrade_warning=upgrade_warning,
)

# -- General configuration ---------------------------------------------------

# If your documentation needs a minimal Sphinx version, state it here.
#
# needs_sphinx = '1.0'

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'openstackdocstheme',
    'sphinx.ext.autodoc',
    'sphinx.ext.extlinks',
    'sphinx.ext.viewcode',
    'sphinxmark'
]

todo_include_docs = True

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# The suffix(es) of source filenames.
source_suffix = '.rst'

# The master toctree document.
master_doc = 'index'

# openstackdocstheme options
repository_name = 'openstack/openstack-chef-repo'
bug_project = 'openstack-chef'
bug_tag = ''

# The language for content autogenerated by Sphinx. Refer to documentation
# for a list of supported languages.
#
# This is also used if you do content translation via gettext catalogs.
# Usually you set "language" from the command line for these cases.
language = None

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path .
exclude_patterns = ['_build']

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = 'sphinx'

# If true, `todo` and `todoList` produce output, else they produce nothing.
todo_include_todos = False

# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'openstackdocs'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# Add any extra paths that contain custom files (such as robots.txt or
# .htaccess) here, relative to this directory. These files are copied
# directly to the root of the documentation.
# html_extra_path = []

# If not '', a 'Last updated on:' timestamp is inserted at every page bottom,
# using the given strftime format.
html_last_updated_fmt = '%Y-%m-%d %H:%M'

# Theme options are theme-specific and customize the look and feel of a theme
# further.  For a list of options available for each theme, see the
# documentation.
#
# html_theme_options = {}

# The default sidebars (for documents that don't match any pattern) are
# defined by theme itself.  Builtin themes are using these templates by
# default: ``['localtoc.html', 'relations.html', 'sourcelink.html',
# 'searchbox.html']``.
#
# html_sidebars = {}


# -- Options for HTMLHelp output ---------------------------------------------

# Output file base name for HTML help builder.
htmlhelp_basename = 'chef-openstack-docs'

# If true, publish source files
html_copy_source = False

# -- Options for LaTeX output ------------------------------------------------

latex_elements = {
    # The paper size ('letterpaper' or 'a4paper').
    #
    # 'papersize': 'letterpaper',

    # The font size ('10pt', '11pt' or '12pt').
    #
    # 'pointsize': '10pt',

    # Additional stuff for the LaTeX preamble.
    #
    # 'preamble': '',

    # Latex figure (float) alignment
    #
    # 'figure_align': 'htbp',
}

# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title,
#  author, documentclass [howto, manual, or own class]).
latex_documents = [
  (master_doc, target_name + '.tex',
   title, author, 'manual'),
]

# -- Options for manual page output ------------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = [
    (master_doc, target_name,
     title, [author], 1)
]


# -- Options for Texinfo output ----------------------------------------------

# Grouping the document tree into Texinfo files. List of tuples
# (source start file, target name, title, author,
#  dir menu entry, description, category)
texinfo_documents = [
    (master_doc, target_name,
     title, author, bug_project,
     description, category),
]

# -- Options for PDF output --------------------------------------------------

pdf_documents = [
    (master_doc, target_name,
     title, author)
]

# -- Options for sphinxmark -----------------------------------------------
sphinxmark_enable = True
sphinxmark_div = 'docs-body'
sphinxmark_image = 'text'
sphinxmark_text = watermark
sphinxmark_text_color = (128, 128, 128)
sphinxmark_text_size = 70
