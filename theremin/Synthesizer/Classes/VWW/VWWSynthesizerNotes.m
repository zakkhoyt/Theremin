//
//  VWWSynthesizerNotes.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 8/12/12.
//  Copyright (c) 2012 Zakk Hoyt. All rights reserved.
//

#import "VWWSynthesizerNotes.h"


@interface VWWSynthesizerNotes ()
@property (nonatomic, strong) NSArray* notesInChromatic;
@property (nonatomic, strong) NSArray* notesInAMinor;
@property (nonatomic, strong) NSArray* notesInAMajor;
@property (nonatomic, strong) NSArray* notesInBMinor;
@property (nonatomic, strong) NSArray* notesInBMajor;
@property (nonatomic, strong) NSArray* notesInCMinor;
@property (nonatomic, strong) NSArray* notesInCMajor;
@property (nonatomic, strong) NSArray* notesInDMinor;
@property (nonatomic, strong) NSArray* notesInDMajor;
@property (nonatomic, strong) NSArray* notesInEMinor;
@property (nonatomic, strong) NSArray* notesInEMajor;
@property (nonatomic, strong) NSArray* notesInFMinor;
@property (nonatomic, strong) NSArray* notesInFMajor;
@property (nonatomic, strong) NSArray* notesInGMinor;
@property (nonatomic, strong) NSArray* notesInGMajor;

-(void)initializeClass;
@end

@implementation VWWSynthesizerNotes


+(VWWSynthesizerNotes *)sharedInstance{
    static VWWSynthesizerNotes* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VWWSynthesizerNotes alloc]init];
    });
    return instance;
}


-(id)init{
    self = [super init];
    if(self){
        [self initializeClass];
    }
    return self;
}

-(void)initializeClass{
    [self initializeAllNotes];
    [self initializeNotesInAMinor];
    [self initializeNotesInAMajor];
    [self initializeNotesInBMinor];
    [self initializeNotesInBMajor];
    [self initializeNotesInCMajor];
    [self initializeNotesInDMinor];
    [self initializeNotesInDMajor];
    [self initializeNotesInEMinor];
    [self initializeNotesInEMajor];
    [self initializeNotesInFMajor];
    [self initializeNotesInGMinor];
    [self initializeNotesInGMajor];
}


+(float)getClosestNoteForFrequency:(float)frequency inKey:(VWWAutoTuneType)key{
    NSArray *notesForKey = [[VWWSynthesizerNotes sharedInstance] notesForKey:key];
    return [[VWWSynthesizerNotes sharedInstance]getClosestNoteForFrequency:frequency notes:notesForKey];
}



-(NSArray*)notesForKey:(VWWAutoTuneType)key{
    switch(key){
        case VWWAutoTuneTypeAMinor:
            return self.notesInAMinor;
        case VWWAutoTuneTypeAMajor:
            return self.notesInAMajor;
        case VWWAutoTuneTypeBMinor:
            return self.notesInBMinor;
        case VWWAutoTuneTypeBMajor:
            return self.notesInBMajor;
        case VWWAutoTuneTypeCMinor:
            return self.notesInCMinor;
        case VWWAutoTuneTypeCMajor:
            return self.notesInCMajor;
        case VWWAutoTuneTypeDMinor:
            return self.notesInDMinor;
        case VWWAutoTuneTypeDMajor:
            return self.notesInDMajor;
        case VWWAutoTuneTypeEMinor:
            return self.notesInEMinor;
        case VWWAutoTuneTypeEMajor:
            return self.notesInEMajor;
        case VWWAutoTuneTypeFMinor:
            return self.notesInFMinor;
        case VWWAutoTuneTypeFMajor:
            return self.notesInFMajor;
        case VWWAutoTuneTypeGMinor:
            return self.notesInGMinor;
        case VWWAutoTuneTypeGMajor:
            return self.notesInGMajor;
        case VWWAutoTuneTypeChromatic:
        default:
            return self.notesInChromatic;
    }
}
-(float)getClosestNoteForFrequency:(float)frequency notes:(NSArray*)notes{
    
    // Since our notes are sorted ascending, use binary search pattern

    int min = 0;
    int max = (int)notes.count;
    int mid = 0;
    
    bool foundValue = false;
    while(min < max){
        mid = (min + max) / 2;
        //        VWW_LOG_INFO(@"min = %i , max = %i, mid = %i",min,max,mid);
        float temp = ((NSNumber*)(notes)[mid]).floatValue;
        //        VWW_LOG_INFO(@"temp = %f frequency = %f", temp, frequency);
        if (temp == frequency){
            foundValue = true;
            break;
        }
        else if (frequency > ((NSNumber*)(notes)[mid]).floatValue){
            min = mid+1;
        }
        else{
            max = mid-1;
        }
    }
    
    // frequency likely falls between two indicies. See which one it's closer to and return that
    float r = 0;
    if(mid == 0){
        // This is to catch a bug. The code below can potentially try to
        // access objectAtIndex:-1. Just return 0 if we are already at 0
        r = ((NSNumber*)(notes)[mid]).floatValue;
    }
    else{
        if(frequency < ((NSNumber*)(notes)[mid]).floatValue){
            // See if it's closer to mid or mid-1
            float temp1 = fabs(frequency - ((NSNumber*)(notes)[mid]).floatValue);
            float temp2 = fabs(frequency - ((NSNumber*)(notes)[mid-1]).floatValue);
            if(temp1 < temp2)
                r = ((NSNumber*)(notes)[mid]).floatValue;
            else
                r = ((NSNumber*)(notes)[mid-1]).floatValue;
        }
        else{
            // See if it's closer to mid of mid+1
            float temp1 = fabs(frequency - ((NSNumber*)(notes)[mid]).floatValue);
            float temp2 = fabs(frequency - ((NSNumber*)(notes)[mid+1]).floatValue);
            if(temp1 < temp2)
                r = ((NSNumber*)(notes)[mid]).floatValue;
            else
                r = ((NSNumber*)(notes)[mid+1]).floatValue;
        }
    }
    return r;
}




// I precalculated these frequendies with the formula f = 2^n/12 * 27.5 with n from 1 .. 114
-(void)initializeAllNotes{
    self.notesInChromatic = @[@(27.50),
                              @(29.14),
                              @(30.87),
                              @(32.70),
                              @(34.65),
                              @(36.71),
                              @(38.89),
                              @(41.20),
                              @(43.65),
                              @(46.25),
                              @(49.00),
                              @(51.91),
                              @(55.00),
                              @(58.27),
                              @(61.74),
                              @(65.41),
                              @(69.30),
                              @(73.42),
                              @(77.78),
                              @(82.41),
                              @(87.31),
                              @(92.50),
                              @(98.00),
                              @(103.83),
                              @(110.00),
                              @(116.54),
                              @(123.47),
                              @(130.81),
                              @(138.59),
                              @(146.83),
                              @(155.56),
                              @(164.81),
                              @(174.61),
                              @(185.00),
                              @(196.00),
                              @(207.65),
                              @(220.00),
                              @(233.08),
                              @(246.94),
                              @(261.63),
                              @(277.18),
                              @(293.66),
                              @(311.13),
                              @(329.63),
                              @(349.23),
                              @(369.99),
                              @(392.00),
                              @(415.30),
                              @(440.00),
                              @(466.16),
                              @(493.88),
                              @(523.25),
                              @(554.37),
                              @(587.33),
                              @(622.25),
                              @(659.26),
                              @(698.46),
                              @(739.99),
                              @(783.99),
                              @(830.61),
                              @(880.00),
                              @(932.33),
                              @(987.77),
                              @(1046.50),
                              @(1108.73),
                              @(1174.66),
                              @(1244.51),
                              @(1318.51),
                              @(1396.91),
                              @(1479.98),
                              @(1567.98),
                              @(1661.22),
                              @(1760.00),
                              @(1864.66),
                              @(1975.53),
                              @(2093.00),
                              @(2217.46),
                              @(2349.32),
                              @(2489.02),
                              @(2637.02),
                              @(2793.83),
                              @(2959.96),
                              @(3135.96),
                              @(3322.44),
                              @(3520.00),
                              @(3729.31),
                              @(3951.07),
                              @(4186.01),
                              @(4434.92),
                              @(4698.64),
                              @(4978.03),
                              @(5274.04),
                              @(5587.65),
                              @(5919.91),
                              @(6271.93),
                              @(6644.88),
                              @(7040.00),
                              @(7458.62),
                              @(7902.13),
                              @(8372.02),
                              @(8869.84),
                              @(9397.27),
                              @(9956.06),
                              @(10548.08),
                              @(11175.30),
                              @(11839.82),
                              @(12543.85),
                              @(13289.75),
                              @(14080.00),
                              @(14917.24),
                              @(15804.27),
                              @(16744.04),
                              @(17739.69),
                              @(18794.55),
                              @(19912.13)];
}


-(NSArray*)minorNotesWithOffset:(NSUInteger)offset{
    //// minor = 0, 2, 3, 5, 7, 8, 10,
    // Guitar pattern
    //D:xAxCx
    //A:x5x78
    //E:x0x23
    
    NSMutableArray *notes = [[NSMutableArray alloc]initWithCapacity:self.notesInChromatic.count * 8 / 12];
    for(NSUInteger index = offset; index < self.notesInChromatic.count - offset; index++){
        NSNumber *frequency = self.notesInChromatic[index];
        
        
        NSUInteger octive = index % 12;
        if(octive == 0){
            [notes addObject:frequency];
        } else if(octive == 2){
            [notes addObject:frequency];
        } else if(octive == 3){
            [notes addObject:frequency];
        } else if(octive == 5){
            [notes addObject:frequency];
        } else if(octive == 7){
            [notes addObject:frequency];
        } else if(octive == 8){
            [notes addObject:frequency];
        } else if(octive == 0x0A){
            [notes addObject:frequency];
        }
    }
    
    return [NSArray arrayWithArray:notes];
}

-(NSArray*)majorNotesWithOffset:(NSUInteger)offset{
    //// major = 0, 2, 4, 5, 7, 9, 11
    // Guitar pattern
    //D:9xBCx
    //A:45x7x
    //E:x0x2x
    
    NSMutableArray *notes = [[NSMutableArray alloc]initWithCapacity:self.notesInChromatic.count * 8 / 12];
    for(NSUInteger index = offset; index < self.notesInChromatic.count - offset; index++){
        NSNumber *frequency = self.notesInChromatic[index];
        
        NSUInteger octive = index % 12;
        if(octive == 0){
            [notes addObject:frequency];
        } else if(octive == 2){
            [notes addObject:frequency];
        } else if(octive == 4){
            [notes addObject:frequency];
        } else if(octive == 5){
            [notes addObject:frequency];
        } else if(octive == 7){
            [notes addObject:frequency];
        } else if(octive == 9){
            [notes addObject:frequency];
        } else if(octive == 11){
            [notes addObject:frequency];
        }
    }
    
    return [NSArray arrayWithArray:notes];
}



-(void)initializeNotesInAMinor{
    _notesInAMinor = [self minorNotesWithOffset:0];
}

-(void)initializeNotesInAMajor{
    _notesInAMajor = [self majorNotesWithOffset:0];
}
-(void)initializeNotesInBMinor{
    _notesInBMinor = [self minorNotesWithOffset:2];
}
-(void)initializeNotesInBMajor{
    _notesInBMajor = [self majorNotesWithOffset:2];
}
-(void)initializeNotesInCMinor{
    _notesInCMinor = [self minorNotesWithOffset:4];
}
-(void)initializeNotesInCMajor{
    _notesInCMajor = [self majorNotesWithOffset:4];
}
-(void)initializeNotesInDMinor{
    _notesInDMinor = [self minorNotesWithOffset:5];
}
-(void)initializeNotesInDMajor{
    _notesInDMajor = [self majorNotesWithOffset:5];
}
-(void)initializeNotesInEMinor{
    _notesInEMinor = [self minorNotesWithOffset:7];
}
-(void)initializeNotesInEMajor{
    _notesInEMajor = [self majorNotesWithOffset:7];
}
-(void)initializeNotesInFMinor{
    _notesInFMinor = [self minorNotesWithOffset:9];
}

-(void)initializeNotesInFMajor{
    _notesInFMajor = [self majorNotesWithOffset:9];
}
-(void)initializeNotesInGMinor{
    _notesInEMinor = [self minorNotesWithOffset:11];
}
-(void)initializeNotesInGMajor{
    _notesInGMajor = [self majorNotesWithOffset:11];
}




@end



