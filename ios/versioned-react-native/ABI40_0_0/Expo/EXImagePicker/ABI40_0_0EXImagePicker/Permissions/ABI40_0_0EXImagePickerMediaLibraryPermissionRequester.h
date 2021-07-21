// Copyright 2017-present 650 Industries. All rights reserved.

#import <ABI40_0_0UMPermissionsInterface/ABI40_0_0UMPermissionsInterface.h>
#import <Photos/Photos.h>

@interface ABI40_0_0EXImagePickerMediaLibraryPermissionRequester : NSObject<ABI40_0_0UMPermissionsRequester>

#if __IPHONE_14_0
- (PHAccessLevel)accessLevel API_AVAILABLE(ios(14));
#endif

@end
