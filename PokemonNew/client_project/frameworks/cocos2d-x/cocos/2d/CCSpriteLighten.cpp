/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/

#include "2d/CCSpriteLighten.h"

#include "2d/CCSpriteFrame.h"
#include "2d/CCSpriteFrameCache.h"
#include "renderer/CCTextureCache.h"
#include "renderer/CCTexture2D.h"
#include "renderer/CCRenderer.h"
#include "renderer/ccGLStateCache.h"

NS_CC_BEGIN

#if CC_SPRITEBATCHNODE_RENDER_SUBPIXEL
#define RENDER_IN_SUBPIXEL
#else
#define RENDER_IN_SUBPIXEL(__ARGS__) (ceil(__ARGS__))
#endif

// MARK: create, init, dealloc

SpriteLighten* SpriteLighten::create()
{
	SpriteLighten *sprite = new (std::nothrow) SpriteLighten();
	if (sprite && sprite->init())
	{
		sprite->autorelease();
		return sprite;
	}
	CC_SAFE_DELETE(sprite);
	return nullptr;
}

SpriteLighten* SpriteLighten::create(const std::string& filename)
{
    SpriteLighten *sprite = new (std::nothrow) SpriteLighten();
    if (sprite && sprite->initWithFile(filename))
    {
        sprite->autorelease();
        return sprite;
    }
    CC_SAFE_DELETE(sprite);
    return nullptr;
}

SpriteLighten* SpriteLighten::create(const std::string& filename, const Rect& rect)
{
    SpriteLighten *sprite = new (std::nothrow) SpriteLighten();
    if (sprite && sprite->initWithFile(filename, rect))
    {
        sprite->autorelease();
        return sprite;
    }
    CC_SAFE_DELETE(sprite);
    return nullptr;
}

SpriteLighten* SpriteLighten::createWithSpriteFrame(SpriteFrame *spriteFrame)
{
    SpriteLighten *sprite = new (std::nothrow) SpriteLighten();
    if (sprite && spriteFrame && sprite->initWithSpriteFrame(spriteFrame))
    {
        sprite->autorelease();
        return sprite;
    }
    CC_SAFE_DELETE(sprite);
    return nullptr;
}

SpriteLighten* SpriteLighten::createWithSpriteFrameName(const std::string& spriteFrameName)
{
    SpriteFrame *frame = SpriteFrameCache::getInstance()->getSpriteFrameByName(spriteFrameName);
    
#if COCOS2D_DEBUG > 0
    char msg[256] = {0};
    sprintf(msg, "Invalid spriteFrameName: %s", spriteFrameName.c_str());
    CCASSERT(frame != nullptr, msg);
#endif
    
    return createWithSpriteFrame(frame);
}

 SpriteLighten::SpriteLighten()
 {
 }

 SpriteLighten::~SpriteLighten()
 {
 }

// designated initializer
bool SpriteLighten::initWithTexture(Texture2D *texture, const Rect& rect, bool rotated)
{
    bool result = false;
    if (Sprite::initWithTexture(texture, rect, rotated))
    {
        // shader state
        setGLProgramState(GLProgramState::getOrCreateWithGLProgramName(GLProgram::SHADER_NAME_POSITION_TEXTURE_COLOR_LIGHTEN_NO_MVP));

        result = true;
    }

    return result;
}

void SpriteLighten::draw(Renderer *renderer, const Mat4 &transform, uint32_t flags)
{
#if CC_USE_CULLING
	// Don't do calculate the culling if the transform was not updated
	_insideBounds = (flags & FLAGS_TRANSFORM_DIRTY) ? renderer->checkVisibility(transform, _contentSize) : _insideBounds;

	if(_insideBounds)
#endif
	{
		_customCommand.init(_globalZOrder, transform, flags);
		_customCommand.func = CC_CALLBACK_0(SpriteLighten::onDraw, this, renderer, transform, flags);

		renderer->addCommand(&_customCommand);
	}

	Sprite::draw(renderer, transform, flags);
}

void SpriteLighten::onDraw(Renderer *renderer, const Mat4& transform, uint32_t flags)
{
	auto glProgramState = getGLProgramState();
	//glProgramState->setUniformVec4("u_colorOffset", Vec4(_colorOffset.r, _colorOffset.g, _colorOffset.b, _colorOffset.a));
	//setGLProgramState(glProgramState);
	//glProgramState->setUniformVec4("u_color", Vec4(_colorOffset.r, _colorOffset.g, _colorOffset.b, _colorOffset.a));
}

NS_CC_END
