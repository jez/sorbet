# frozen_string_literal: true
require_relative '../test_helper'

class Opus::Types::Test::FinalTest < Critic::Unit::UnitTest
  after do
    T::Private::DeclState.current.reset!
  end

  it "allows declaring an instance method as final" do
    Class.new do
      extend T::Sig
      sig(:final) {void}
      def foo; end
    end
  end

  it "allows declaring a class method as final" do
    Class.new do
      extend T::Sig
      sig(:final) {void}
      def self.foo; end
    end
  end

  it "forbids redefining a final instance method with a final sig" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Sig
        sig(:final) {void}
        def foo; end
        sig(:final) {void}
        def foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be redefined")
  end

  it "forbids redefining a final class method with a final sig" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Sig
        sig(:final) {void}
        def self.foo; end
        sig(:final) {void}
        def self.foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be redefined")
  end

  it "forbids redefining a final instance method with a regular sig" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Sig
        sig(:final) {void}
        def foo; end
        sig {void}
        def foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be redefined")
  end

  it "forbids redefining a final class method with a regular sig" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Sig
        sig(:final) {void}
        def self.foo; end
        sig {void}
        def self.foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be redefined")
  end

  it "forbids redefining a final instance method with no sig" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Sig
        sig(:final) {void}
        def foo; end
        def foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be redefined")
  end

  it "forbids redefining a final class method with no sig" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Sig
        sig(:final) {void}
        def self.foo; end
        def self.foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be redefined")
  end

  it "allows redefining a regular instance method to be final" do
    Class.new do
      extend T::Sig
      def foo; end
      sig(:final) {void}
      def foo; end
    end
  end

  it "allows redefining a regular class method to be final" do
    Class.new do
      extend T::Sig
      def self.foo; end
      sig(:final) {void}
      def self.foo; end
    end
  end

  it "forbids overriding a final instance method" do
    c = Class.new do
      extend T::Sig
      sig(:final) {void}
      def foo; end
    end
    err = assert_raises(RuntimeError) do
      Class.new(c) do
        def foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be overridden")
  end

  it "forbids overriding a final class method" do
    c = Class.new do
      extend T::Sig
      sig(:final) {void}
      def self.foo; end
    end
    err = assert_raises(RuntimeError) do
      Class.new(c) do
        def self.foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be overridden")
  end

  it "forbids overriding a final method from an included module" do
    m = Module.new do
      extend T::Sig
      sig(:final) {void}
      def foo; end
    end
    err = assert_raises(RuntimeError) do
      Class.new do
        include m
        def foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be overridden")
  end

  it "forbids overriding a final method from an extended module" do
    m = Module.new do
      extend T::Sig
      sig(:final) {void}
      def foo; end
    end
    err = assert_raises(RuntimeError) do
      Class.new do
        extend m
        def self.foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be overridden")
  end

  it "forbids overriding a final method by including two modules" do
    m1 = Module.new do
      extend T::Sig
      sig(:final) {void}
      def foo; end
    end
    m2 = Module.new do
      def foo; end
    end
    err = assert_raises(RuntimeError) do
      Class.new do
        include m1
        include m2
      end
    end
    assert_includes(err.message, "was declared as final and cannot be overridden")
  end

  it "forbids overriding a final method by extending two modules" do
    m1 = Module.new do
      extend T::Sig
      sig(:final) {void}
      def foo; end
    end
    m2 = Module.new do
      def foo; end
    end
    err = assert_raises(RuntimeError) do
      Class.new do
        extend m1
        extend m2
      end
    end
    assert_includes(err.message, "was declared as final and cannot be overridden")
  end
end
