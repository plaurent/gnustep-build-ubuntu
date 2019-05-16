#!/bin/bash

cat > guitest.m << EOF
#import <AppKit/AppKit.h>

int main()
{
  NSApplication *app;  // Without these 2 lines, seg fault may occur
  app = [NSApplication sharedApplication];

  NSAlert * alert = [[NSAlert alloc] init];
  [alert setMessageText:@"Hello alert"];
  [alert addButtonWithTitle:@"All done"];
  int result = [alert runModal];
  if (result == NSAlertFirstButtonReturn) {
    NSLog(@"First button pressed");
  }
}
EOF

# ======================================================================
# COMPILE USING THE FOLLOWING COMMAND LINES, OR CREATE A MAKEFILE
# ======================================================================

# Set compiler
if [ -x "$(command -v ${CC})" ]; then
  echo "Using CC from environment variable: ${CC}"
else
  if [ -x "$(command -v clang-8)" ]; then
    CC=clang-8
  elif [ -x "$(command -v clang)" ]; then
    CC=clang
  else
    echo 'Error: clang seems not to be in PATH. Please check your $PATH.' >&2
    exit 1
  fi
fi

# Using COMMAND LINE
echo "Compiling and running GUI + ARC demo (command line compilation)."
${CC} `gnustep-config --objc-flags` `gnustep-config --objc-libs` -lobjc -fobjc-arc -ldispatch -lgnustep-base -lgnustep-gui  guitest.m
./a.out

# Using MAKEFILE
cat > GNUmakefile << EOF
include \$(GNUSTEP_MAKEFILES)/common.make
OBJCFLAGS = -fobjc-arc
APP_NAME = GUITest
GUITest_OBJC_FILES = guitest.m
include \$(GNUSTEP_MAKEFILES)/application.make
EOF

echo "Compiling and running GUI + ARC demo (makefile compilation)."
make
openapp ./GUITest.app
