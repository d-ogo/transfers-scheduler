//
//  DTMacros.h
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 9/2/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#ifndef Transfers_Scheduler_DTMacros_h
#define Transfers_Scheduler_DTMacros_h

// Useful macros

#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex : 0]

#define LibraryDirectory [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, \
NSUserDomainMask, YES) objectAtIndex : 0]

#define DocumentsSubDirectory(dir) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex : 0] stringByAppendingString : dir]

#define LibrarySubDirectory(dir) [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, \
NSUserDomainMask, YES) objectAtIndex : 0] stringByAppendingString : dir]

#define CacheDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex : 0]


#ifdef DEBUG
#define DTLogD(format, ...) {NSLog(@ "[Log D] %s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat: format, ## __VA_ARGS__]); }
#define DTLog(format, ...) {NSLog(@ "[Log] %s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat: format, ## __VA_ARGS__]); }
#else
#define DTLogD(format, ...)
#define DTLog(format, ...) {NSLog(@ "%@", [NSString stringWithFormat: format, ## __VA_ARGS__]); }
#endif

// Only needed for Xcode 4.4.1 and earlier
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

#endif
