local glue = require 'glue'
local lust = require 'lib.lust'
local describe, it, expect, before = lust.describe, lust.it, lust.expect, lust.before

local Yui = require 'src.yui'

local BOOT_CTOR = function() return 'boot' end
local LOGIN_CTOR = function() return 'login' end

describe('Arena', function()
  before(function()
    Yui:register('boot', BOOT_CTOR)
    Yui:register('login', LOGIN_CTOR)
  end)

  describe('Yui', function()
    it('register', function()
      expect(Yui.scenes).to.equal {
        boot = BOOT_CTOR,
        login = LOGIN_CTOR
      }

      expect(glue.count(Yui.scenes)).to.be(2)
    end)

    it('call', function()
      Yui:call('boot')
      expect(Yui.scene).to.be('boot')
      expect(Yui.stack['boot']).to.be('boot')
    end)

    it('goTo', function()
      Yui:call('boot')
      Yui:call('login')

      Yui:goTo('boot')
      expect(Yui.scene).to.be('boot')

      Yui:goTo('login')
      expect(Yui.scene).to.be('login')
    end)
  end)
end)
