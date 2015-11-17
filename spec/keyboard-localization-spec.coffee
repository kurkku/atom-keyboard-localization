path = require('path')
fs = require('fs')
KeyboardLocalization = require '../lib/keyboard-localization.coffee'

describe 'KeyboardLocalization', ->
  pkg = []

  beforeEach ->
    pkg = KeyboardLocalization
    waitsForPromise -> atom.packages.activatePackage('keyboard-localization')

  describe 'when the package loads', ->
    it 'should be an keymap-locale-file available for every config entry', ->
      pkg.config.useKeyboardLayout.enum.forEach (localeString) ->
        pathToKeymapFile = path.join(__dirname, '..', 'lib', 'keymaps', localeString + '.json')
        expect(fs.existsSync(pathToKeymapFile)).toBe true

    it 'should activate', ->
      expect(atom.packages.isPackageActive('keyboard-localization'))

  describe 'configuration', ->
    it 'should be able to load every keymap-locale successfully', ->
      pkg.config.useKeyboardLayout.enum.forEach (localeString) ->
        atom.config.set('keyboard-localization.useKeyboardLayout', localeString)
        expect(pkg.keymapLoader.getKeymapName()).toEqual(localeString)
