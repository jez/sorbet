#include <ruby_parser/driver.hh>
#include <ruby_parser/lexer.hh>

// Autogenerated code
#include "typedruby_bison.h"

namespace ruby_parser {

base_driver::base_driver(ruby_version version, const std::string& source, const struct builder& builder)
	: build(builder),
	lex(diagnostics, version, source),
	pending_error(false),
	def_level(0),
	ast(nullptr)
{
}

typedruby25::typedruby25(const std::string& source, const struct builder& builder)
	: base_driver(ruby_version::RUBY_25, source, builder)
{}

foreign_ptr typedruby25::parse(self_ptr self) {
	bison::typedruby25::parser p(*this, self);
	p.parse();
	return ast;
}

}
