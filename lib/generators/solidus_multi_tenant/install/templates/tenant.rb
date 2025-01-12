# frozen_string_literal: true

module Spree
# Tenant model manages multi-tenancy configuration and database operations
  class Tenant < ApplicationRecord
    after_destroy :drop_tenant
    after_save :create_tenant
    after_commit :reset_cache_key, on: [:create, :update, :destroy]

    validates :name, presence: true, uniqueness: true
    validates :match, presence: true, uniqueness: true

    private

    def create_tenant
      ::Apartment::Tenant.create(name)
    end

    def drop_tenant
      # do not automatically drop DB schema in prod for safety.
      return if Rails.env.production?

      ::Apartment::Tenant.drop(name)
    end

    def reset_cache_key
      Rails.cache.delete("tenant_names")
    end
  end
end
