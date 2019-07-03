# frozen_string_literal: true
require_relative '../test_helper'

class Opus::Types::Test::FinalTest < Critic::Unit::UnitTest
  after do
    T::Private::DeclState.current.reset!
  end

  it "allows declaring a class as final" do
    Class.new do
      extend T::Helpers
      final!
    end
  end

  it "allows declaring a module as final" do
    Module.new do
      extend T::Helpers
      final!
    end
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

  it "forbids inheriting from a final class" do
    c = Class.new do
      extend T::Helpers
      final!
    end
    err = assert_raises(RuntimeError) do
      Class.new(c)
    end
    assert_includes(err.message, "was declared as final and cannot be inherited from")
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

  it "forbids declaring a class as final and its instance method as final" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Helpers
        final!
        extend T::Sig
        sig {void}.final
        def foo; end
      end
    end
    assert_includes(err.message, "was declared as final and its method")
    assert_includes(err.message, "cannot also be explicitly declared as final (it is implicitly final)")
  end

  it "forbids declaring a class as final and its instance method as final" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Helpers
        final!
        extend T::Sig
        sig {void}.final
        def self.foo; end
      end
    end
    assert_includes(err.message, "was declared as final and its method")
    assert_includes(err.message, "cannot also be explicitly declared as final (it is implicitly final)")
  end

  it "forbids declaring a class as final and then abstract" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Helpers
        final!
        abstract!
      end
    end
    assert_includes(err.message, "was already declared as final and cannot be declared as abstract")
  end

  it "forbids declaring a class as abstract and then final" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Helpers
        abstract!
        final!
      end
    end
    assert_includes(err.message, "was already declared as abstract and cannot be declared as final")
  end

  it "forbids re-declaring a class as final" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Helpers
        final!
        final!
      end
    end
    assert_includes(err.message, "was already declared as final and cannot be re-declared as final")
  end

  it "forbids declaring a non-module, non-method as final" do
    err = assert_raises(RuntimeError) do
      Array.new(1) do
        extend T::Helpers
        final!
      end
    end
    assert_includes(err.message, "is not a module or method and cannot be declared as final")
  end

  it "marks the methods of a final module as final" do
    mod = Module.new do
      extend T::Helpers
      final!
      def self.foo; 1; end
    end
    err = assert_raises(RuntimeError) do
      def mod.foo; 2; end
    end
    assert_includes(err.message, "was declared as final and cannot be redefined")
  end
end
