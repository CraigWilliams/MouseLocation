#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <AppKit/AppKit.h>

#define defs [NSUserDefaults standardUserDefaults]

void WriteStringToPasteboard(NSString *string) {
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	[pb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
	[pb setString:string forType:NSStringPboardType];
	[pb stringForType:NSStringPboardType];
}

void ShowHelp() {
	printf("Usage:\n");
	printf("	MouseLocation [h|help|fp]\n"); 
	printf("		-h or -help will display this help message\n");
	printf("		-p will copy the mouse coordinates to pasteboard\n");
	printf("		-f will format the output for use with the cliclick cli.\n");
	printf("\n");
	printf("You cannot put 'f' and 'p' together like -fp.\n");
	printf("They must be separate and each one preceeded by a dash like '-f -p'.\n");
}

int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString *mouseCoordinates;
	NSArray *help = [NSArray arrayWithObjects:@"-h", @"-help", nil];
	NSArray *pInfo = [NSArray arrayWithArray:[[NSProcessInfo processInfo] arguments]];
	
	if ( [pInfo count] == 1 ) {
		ShowHelp();
	}
	else if ( [help containsObject:[pInfo objectAtIndex:1]] ) {
		ShowHelp();
	}
	else {
		HIPoint point;
		HICoordinateSpace space = 2;
		HIGetMousePosition(space, NULL, &point);
		
		if ( [pInfo containsObject:@"-f"] ) {
			mouseCoordinates = [NSString stringWithFormat:@"cliclick %.2f %.2f", point.x, point.y];
		}
		else {
			mouseCoordinates = [NSString stringWithFormat:@"%.2f %.2f", point.x, point.y];
		}
		
		if ( [pInfo containsObject:@"-p"] ) {
			WriteStringToPasteboard(mouseCoordinates);
		}
		else {
			printf("%s", [mouseCoordinates UTF8String]);
		}
		
	}
	
	[pool drain];
	return 0;
}