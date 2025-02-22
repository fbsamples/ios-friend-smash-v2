/**
 * Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
 *
 * You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
 * copy, modify, and distribute this software in source code or binary form for use
 * in connection with the web services and APIs provided by Facebook.
 *
 * As with any software that integrates with the Facebook platform, your use of
 * this software is subject to the Facebook Developer Principles and Policies
 * [http://developers.facebook.com/policy/]. This copyright notice shall be
 * included in all copies or substantial portions of the software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include "ShaderProgram.h"
#include "GenericShaders.h"
#include "debug.h"

using namespace FriendSmasher;
using namespace FriendSmasher::System;
using namespace FriendSmasher::Math;

ShaderProgram::ShaderProgram( const char* vertexProgram, const char* fragmentProgram )
{
	int success;
	FBAssert(glGetError() == GL_NO_ERROR);
	
	// Create vertex shader
	m_vertexShader = glCreateShader( GL_VERTEX_SHADER );
	glShaderSource( m_vertexShader, 1, &vertexProgram, NULL );
	glCompileShader( m_vertexShader );
	
	// Check for success
	glGetShaderiv(m_vertexShader, GL_COMPILE_STATUS, &success);
	if (success == 0)
	{
		char errorMsg[2048];
		glGetShaderInfoLog(m_vertexShader, sizeof(errorMsg), NULL, errorMsg);
		printf("Compile error: %s\n", errorMsg);
		glDeleteShader(m_vertexShader);
		FBAssert(false);
	}
	
	// Create the fragment shader
	m_fragmentShader = glCreateShader( GL_FRAGMENT_SHADER );
	glShaderSource( m_fragmentShader, 1, &fragmentProgram, NULL );
	glCompileShader( m_fragmentShader );
	
	// Check for success
	glGetShaderiv(m_fragmentShader, GL_COMPILE_STATUS, &success);
	if (success == 0)
	{
		char errorMsg[2048];
		glGetShaderInfoLog(m_fragmentShader, sizeof(errorMsg), NULL, errorMsg);
		printf("Compile error: %s\n", errorMsg);
		glDeleteShader(m_fragmentShader);
		FBAssert(false);
	}
	
	// Create shader program and initialise
	m_shaderProgram = glCreateProgram( );
	glAttachShader( m_shaderProgram, m_vertexShader );
	glAttachShader( m_shaderProgram, m_fragmentShader );
	
	glLinkProgram( m_shaderProgram );
	
	FBAssert(glGetError() == GL_NO_ERROR);
}


ShaderProgram::~ShaderProgram( )
{
	FBAssert(glGetError() == GL_NO_ERROR);
	
	glDetachShader( m_shaderProgram, m_vertexShader );
	glDetachShader( m_shaderProgram, m_fragmentShader );
	
	glDeleteShader( m_vertexShader );
	glDeleteShader( m_fragmentShader );
	
	glDeleteProgram( m_shaderProgram );
	
	m_vertexShader		= NULL;
	m_fragmentShader	= NULL;
	m_shaderProgram		= NULL;
	
	FBAssert(glGetError() == GL_NO_ERROR);
}

void ShaderProgram::Bind( )
{
	glUseProgram( m_shaderProgram );
}

void ShaderProgram::Unbind( )
{
	glUseProgram( 0 );
}

void ShaderProgram::BindAttributeLocation( u32 location, const char* attribName )
{
	glBindAttribLocation( m_shaderProgram, location, attribName );	
	glLinkProgram( m_shaderProgram );
	FBAssert(glGetError() == GL_NO_ERROR);
}

int ShaderProgram::GetUniformLocation( const char* name )
{
	int loc = glGetUniformLocation( m_shaderProgram, name );
	
	//FBAssert( loc != -1 );
	FBAssert(glGetError() == GL_NO_ERROR);
	
	return loc;
}

void ShaderProgram::BindUniform( const char* name, const float val )
{
	int loc = GetUniformLocation( name );
    BindUniform( loc, val );
}

void ShaderProgram::BindUniform( const char* name, const int val )
{
	int loc = GetUniformLocation( name );
    BindUniform( loc, val );
}

void ShaderProgram::BindUniform( const char* name, const u32 val )
{
	int loc = GetUniformLocation( name );
    BindUniform( loc, val );
}

void ShaderProgram::BindUniform( const char* name, const vec2& val )
{
	int loc = GetUniformLocation( name );
    BindUniform( loc, val );
}

void ShaderProgram::BindUniform( const char* name, const vec3& val )
{
	int loc = GetUniformLocation( name );
    BindUniform( loc, val );
}

void ShaderProgram::BindUniform( const char* name, const vec4& val )
{
	int loc = GetUniformLocation( name );
    BindUniform( loc, val );
}

void ShaderProgram::BindUniform( const char* name, const mtx33& val )
{
	int loc = GetUniformLocation( name );
    BindUniform( loc, val );
}

void ShaderProgram::BindUniform( const char* name, const mtx44& val )
{
	int loc = GetUniformLocation( name );
    BindUniform( loc, val );
}

void ShaderProgram::BindUniform( int loc, const float val )
{
    glUniform1f( loc, val );
}

void ShaderProgram::BindUniform( int loc, const int val )
{
    glUniform1i( loc, val );
}

void ShaderProgram::BindUniform( int loc, const u32 val )
{
    glUniform1i( loc, val );
}

void ShaderProgram::BindUniform( int loc, const Math::vec2& val )
{
    glUniform2f( loc, val.x, val.y );
}

void ShaderProgram::BindUniform( int loc, const Math::vec3& val )
{
    glUniform3f( loc, val.x, val.y, val.z );
}

void ShaderProgram::BindUniform( int loc, const Math::vec4& val )
{
    glUniform4f( loc, val.x, val.y, val.z, val.w );
}

void ShaderProgram::BindUniform( int loc, const Math::mtx33& val )
{
    glUniformMatrix3fv( loc, 1, GL_FALSE, (const GLfloat*)&val );
}

void ShaderProgram::BindUniform( int loc, const Math::mtx44& val )
{
    glUniformMatrix4fv( loc, 1, GL_FALSE, (const GLfloat*)&val );
}
