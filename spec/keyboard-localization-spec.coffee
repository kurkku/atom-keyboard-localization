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

  describe 'when the package is deactivated', ->
    it 'should free its resources', ->
      atom.packages.deactivatePackage('keyboard-localization')
      expect(pkg.keymapLoader).toBe null
      expect(pkg.keyMapper).toBe null
      expect(pkg.modifierStateHandler).toBe null
      expect(pkg.keymapGeneratorView).toBe null

    it 'can be deactivated twice', ->
      atom.packages.deactivatePackage('keyboard-localization')
      atom.packages.deactivatePackage('keyboard-localization')

  describe 'configuration', ->
    it 'should be able to load every keymap-locale successfully', ->
      pkg.config.useKeyboardLayout.enum.forEach (localeString) ->
        atom.config.set('keyboard-localization.useKeyboardLayout', localeString)
        expect(pkg.keymapLoader.getKeymapName()).toEqual(localeString)
