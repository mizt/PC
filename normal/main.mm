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
            
            const int W = 256;
            const int H = 144;
            
            if(element_vertex==W*H) {
            
                int stride = (length-seek)/element_vertex;
                NSLog(@"stride = %d",stride);
                
                std::vector<simd::float3> v;
                std::vector<simd::float3> vn;

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
                    
                    for(int i=0; i<H; i++) {
                        for(int j=0; j<W; j++) {
                        
                            simd::float3 normal = simd::float3{0.0,0.0,0.0};
                            simd::float3 c = v[i*W+j];
                            
                            if(j-1>=0&&i-1>=0) {
                                normal+=simd::cross((v[(i-1)*W+(j-1)])-c,(v[(i+0)*W+(j-1)])-c);
                                normal+=simd::cross((v[(i-1)*W+(j+0)])-c,(v[(i-1)*W+(j-1)])-c);
                            }
                            
                            if(j<W-1&&i-1>=0) {
                                normal+=simd::cross((v[(i+0)*W+(j+1)])-c,(v[(i-1)*W+(j+0)])-c);
                            }
                            
                            if(j<W-1&&i<H-1) {
                                normal+=simd::cross((v[(i+1)*W+(j+1)])-c,(v[(i+0)*W+(j+1)])-c);
                                normal+=simd::cross((v[(i+1)*W+(j+1)])-c,(v[(i+1)*W+(j+0)])-c);
                            }
                            
                            if(j-1>=0&&i<H-1) {
                                normal+=simd::cross((v[(i+0)*W+(j-1)])-c,(v[(i+1)*W+(j+0)])-c);
                            }
                            
                            if(!(normal.x==0&&normal.y==0&&normal.z==0)) {
                                normal = simd::normalize(normal);
                            }
                            
                            vn.push_back(normal);
                            
                        }
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
                    
                    for(int n=0; n<vn.size(); n++) {
                        [obj appendString:[NSString stringWithFormat:@"vn %f %f %f\n",
                            vn[n].x,
                            vn[n].y,
                            vn[n].z
                        ]];
                    }
                    
                    for(int i=0; i<H-1; i++) {
                        int i2 = i+1;
                        for(int j=0; j<W-1; j++) {
                            int j2 = j+1;
                            unsigned int f1 = (i*W+j);
                            unsigned int f2 = (i*W+j2);
                            unsigned int f3 = (i2*W+j2);
                            unsigned int f4 = (i2*W+j);
                            
                            [obj appendString:[NSString stringWithFormat:@"f %d//%d %d//%d %d//%d\n",
                                1+f1,1+f1,1+f3,1+f3,1+f2,1+f2
                            ]];
                            
                            [obj appendString:[NSString stringWithFormat:@"f %d//%d %d//%d %d//%d\n",
                                1+f1,1+f1,1+f4,1+f4,1+f3,1+f3
                            ]];
                        }
                    }
                            
                    [obj writeToFile:@"./test.obj" atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    
                    */
                }
            }
        }
    }
}
                