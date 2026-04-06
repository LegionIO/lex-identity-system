# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Extensions::Identity::System::Identity do
  subject(:identity) { described_class }

  # --- provider contract interface ---

  describe '.provider_name' do
    it 'returns :system' do
      expect(identity.provider_name).to eq(:system)
    end
  end

  describe '.provider_type' do
    it 'returns :fallback' do
      expect(identity.provider_type).to eq(:fallback)
    end

    it 'is not :auth' do
      expect(identity.provider_type).not_to eq(:auth)
    end

    it 'is not :profile' do
      expect(identity.provider_type).not_to eq(:profile)
    end
  end

  describe '.facing' do
    it 'returns nil (not applicable for fallback)' do
      expect(identity.facing).to be_nil
    end
  end

  describe '.priority' do
    it 'returns 0 (lowest)' do
      expect(identity.priority).to eq(0)
    end
  end

  describe '.trust_weight' do
    it 'returns 200 (least trusted)' do
      expect(identity.trust_weight).to eq(200)
    end
  end

  describe '.capabilities' do
    it 'returns [:profile] only' do
      expect(identity.capabilities).to eq([:profile])
    end

    it 'does not include :auth' do
      expect(identity.capabilities).not_to include(:auth)
    end
  end

  # --- resolve ---

  describe '.resolve' do
    context 'when ENV[USER] is set to a normal username' do
      before { allow(ENV).to receive(:fetch).with('USER', nil).and_return('jsmith') }

      it 'returns a hash' do
        expect(identity.resolve).to be_a(Hash)
      end

      it 'sets canonical_name to the normalized value' do
        expect(identity.resolve[:canonical_name]).to eq('jsmith')
      end

      it 'sets kind to :human' do
        expect(identity.resolve[:kind]).to eq(:human)
      end

      it 'sets source to :system' do
        expect(identity.resolve[:source]).to eq(:system)
      end

      it 'sets persistent to false' do
        expect(identity.resolve[:persistent]).to be false
      end

      it 'sets groups to an empty array' do
        expect(identity.resolve[:groups]).to eq([])
      end

      it 'includes a profile sub-hash' do
        expect(identity.resolve[:profile]).to be_a(Hash)
      end

      it 'stores the original username in profile' do
        expect(identity.resolve[:profile][:username]).to eq('jsmith')
      end

      it 'stores the hostname in profile' do
        expect(identity.resolve[:profile][:hostname]).to be_a(String)
        expect(identity.resolve[:profile][:hostname]).not_to be_empty
      end
    end

    context 'when ENV[USER] contains uppercase letters' do
      before { allow(ENV).to receive(:fetch).with('USER', nil).and_return('JSmith') }

      it 'lowercases the canonical_name' do
        expect(identity.resolve[:canonical_name]).to eq('jsmith')
      end

      it 'preserves the original username in profile' do
        expect(identity.resolve[:profile][:username]).to eq('JSmith')
      end
    end

    context 'when ENV[USER] contains an @realm suffix' do
      before { allow(ENV).to receive(:fetch).with('USER', nil).and_return('jsmith@EXAMPLE.COM') }

      it 'strips the realm from canonical_name' do
        expect(identity.resolve[:canonical_name]).to eq('jsmithexamplecom')
      end

      it 'preserves the original value in profile' do
        expect(identity.resolve[:profile][:username]).to eq('jsmith@EXAMPLE.COM')
      end
    end

    context 'when ENV[USER] is nil' do
      before { allow(ENV).to receive(:fetch).with('USER', nil).and_return(nil) }

      it 'returns nil' do
        expect(identity.resolve).to be_nil
      end
    end

    context 'when ENV[USER] is an empty string' do
      before { allow(ENV).to receive(:fetch).with('USER', nil).and_return('') }

      it 'returns nil' do
        expect(identity.resolve).to be_nil
      end
    end

    context 'when ENV[USER] is whitespace only' do
      before { allow(ENV).to receive(:fetch).with('USER', nil).and_return('   ') }

      it 'returns nil' do
        expect(identity.resolve).to be_nil
      end
    end

    context 'when ENV[USER] normalizes to an empty string (all special chars)' do
      before { allow(ENV).to receive(:fetch).with('USER', nil).and_return('!!!') }

      it 'returns nil' do
        expect(identity.resolve).to be_nil
      end
    end
  end

  # --- normalize ---

  describe '.normalize' do
    it 'lowercases the value' do
      expect(identity.normalize('ADMIN')).to eq('admin')
    end

    it 'strips leading and trailing whitespace' do
      expect(identity.normalize('  user  ')).to eq('user')
    end

    it 'removes dots (AMQP word separator)' do
      expect(identity.normalize('first.last')).to eq('firstlast')
    end

    it 'removes @ and realm suffix' do
      expect(identity.normalize('user@REALM.COM')).to eq('userrealmcom')
    end

    it 'removes special characters' do
      expect(identity.normalize('user#name!')).to eq('username')
    end

    it 'preserves underscores' do
      expect(identity.normalize('service_account')).to eq('service_account')
    end

    it 'preserves hyphens' do
      expect(identity.normalize('my-service')).to eq('my-service')
    end

    it 'preserves digits' do
      expect(identity.normalize('user42')).to eq('user42')
    end

    it 'handles an empty string' do
      expect(identity.normalize('')).to eq('')
    end

    it 'handles nil by converting to empty string' do
      expect(identity.normalize(nil)).to eq('')
    end
  end

  # --- module-level contract (not an auth or group provider) ---

  describe 'Legion::Extensions::Identity::System' do
    subject(:mod) { Legion::Extensions::Identity::System }

    it 'declares itself as an identity provider' do
      expect(mod.identity_provider?).to be true
    end

    it 'is not remote invocable' do
      expect(mod.remote_invocable?).to be false
    end
  end
end
