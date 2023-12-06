#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AppleIDButton.h"
#import "AppleIDButtonFactory.h"
#import "AuthorizationControllerDelegate.h"
#import "CredentialConverter.h"
#import "NSErrorConverter.h"
#import "Utils.h"
#import "TheAppleSignInPlugin.h"

FOUNDATION_EXPORT double the_apple_sign_inVersionNumber;
FOUNDATION_EXPORT const unsigned char the_apple_sign_inVersionString[];

