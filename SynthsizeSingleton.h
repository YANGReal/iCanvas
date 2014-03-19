//
//  SynthsizeSingleton.h
//  TianHeBay
//
//  Created by  Jason on 13-1-15.
//  Copyright (c) 2013年 BlueBox. All rights reserved.
//

#ifndef Tool_SynthsizeSingleton_h
#define Tool_SynthsizeSingleton_h

#if __has_feature(objc_arc)
#define SYNTHESIZE_SINGLETON_RETAIN_METHODS
#else
#define SYNTHESIZE_SINGLETON_RETAIN_METHODS \
- (id)retain \
{ \
return self; \
} \
\
- (NSUInteger)retainCount \
{ \
return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
return self; \
}
#endif

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##Instance = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##Instance == nil) \
{ \
shared##Instance = [[self alloc] init]; \
} \
} \
\
return shared##Instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##Instance == nil) \
{ \
shared##Instance = [super allocWithZone:zone]; \
return shared##Instance; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\
SYNTHESIZE_SINGLETON_RETAIN_METHODS

#define SYNTHESIZE_SINGLETON_FOR_HEADER(classname) \
+ (classname *) shared##classname;

#endif
