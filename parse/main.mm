#import <Cocoa/Cocoa.h>
#import <simd/simd.h>
#import <vector>


int main(int argc, char *argv[]) {
    @autoreleasepool {
        
        NSData *bin = [[NSData alloc] initWithContentsOfFile:@"../ply/scene.ply"];
        
        if(bin) {
            unsigned char *bytes = (unsigned char *)[bin bytes];
            unsigned long length = [bin length];
            
            NSLog(@"%ld",length);
            
            int element_vertex = 0;
            
            int seek = 0;
            for(; seek<length; seek++) {
                
                unsigned int tmp = *((unsigned int *)(bytes+seek));
                
                if(tmp==0x20786574) {
                    
                    seek+=4;
                    NSMutableString *tmp = [NSMutableString stringWithString:@""];
                    while(true) {
                        [tmp appendString:[NSString stringWithFormat:@"%c",*(bytes+seek)]];
                        
                        if(*(bytes+seek+1)==0x0A) {
                            
                            element_vertex = [tmp intValue];
                            NSLog(@"%d",element_vertex);
                            
                            break;
                        }
                        else {
                            seek++;
                        }
                    }
                    
                }
                else if(tmp==0x0A726564) { // der\n
                    seek+=4;
                    break;
                }
            }
            
            int stride = (length-seek)/element_vertex;
            NSLog(@"stride = %d",stride);
            
            std::vector<simd::float3> v;
            
            if(stride==12) {
                
                /*
                property float x
                property float y
                property float z
                */
                
                unsigned char *data = (unsigned char *)(bytes+seek);

                int offset = 0;
                while(element_vertex--) {
                    
                    v.push_back(
                        simd::float3{
                            *(float *)(data+offset),
                            *(float *)(data+offset+4),
                            *(float *)(data+offset+8),
                        }
                    );
                    
                    offset+=12;
                }
                
                /*
                NSMutableString *obj = [NSMutableString stringWithString:@""];
                
                for(int n=0; n<v.size(); n++) {
                    [obj appendString:[NSString stringWithFormat:@"v %f %f %f\n",
                        v[n].x,
                        v[n].y,
                        v[n].z
                    ]];
                }
                
                [obj writeToFile:@"./test.obj" atomically:YES encoding:NSUTF8StringEncoding error:nil];
                */

            }
        }
    }
}
                