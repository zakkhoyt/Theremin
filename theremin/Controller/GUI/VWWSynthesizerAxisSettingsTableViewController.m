//
//  VWWSynthesizerAxisSettingsTableViewController.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/18/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWSynthesizerAxisSettingsTableViewController.h"
#import "VWWSynthesizerGroup.h"
#import "VWWFrequencyParametersTableViewController.h"
#import "VWWWaveformParametersTableViewController.h"
#import "VWWAmplitudeParametersTableViewController.h"
#import "VWWEffectParametersTableViewController.h"
#import "VWWSensitivityParameterTableViewController.h"
#import "VWWSynthesizersController.h"

const NSInteger VWWSynthesizerAxisFrequencyRow = 0;
const NSInteger VWWSynthesizerAxisWaveformRow = 1;
const NSInteger VWWSynthesizerAxisAmplitudeRow = 2;
const NSInteger VWWSynthesizerAxisEffectRow = 3;
const NSInteger VWWSynthesizerAxisSensitivityRow = 4;

static NSString *VWWSegueAxisToFrequency = @"VWWSegueAxisToFrequency";
static NSString *VWWSegueAxisToWaveform = @"VWWSegueAxisToWaveform";
static NSString *VWWSegueAxisToAmplitude = @"VWWSegueAxisToAmplitude";
static NSString *VWWSegueAxisToEffect = @"VWWSegueAxisToEffect";
static NSString *VWWSegueAxisToSensitivity = @"VWWSegueAxisToSensitivity";

@interface VWWSynthesizerAxisSettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *frequencySummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *waveformSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *amplitudeSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *effectSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *sensitivitySummaryLabel;

@end

@implementation VWWSynthesizerAxisSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.tableView.backgroundColor = nil;
        self.tableView.backgroundColor = [UIColor darkGrayColor];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateControls];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[VWWSynthesizersController sharedInstance] writeSettings];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:VWWSegueAxisToFrequency]){
        VWWFrequencyParametersTableViewController *vc = segue.destinationViewController;
        vc.synthesizerGroup = self.synthesizerGroup;
    } else if([segue.identifier isEqualToString:VWWSegueAxisToWaveform]){
        VWWWaveformParametersTableViewController *vc = segue.destinationViewController;
        vc.synthesizerGroup = self.synthesizerGroup;
    } else if([segue.identifier isEqualToString:VWWSegueAxisToAmplitude]){
        VWWAmplitudeParametersTableViewController *vc = segue.destinationViewController;
        vc.synthesizerGroup = self.synthesizerGroup;
    } else if([segue.identifier isEqualToString:VWWSegueAxisToEffect]){
        VWWEffectParametersTableViewController *vc = segue.destinationViewController;
        vc.synthesizerGroup = self.synthesizerGroup;
    } else if([segue.identifier isEqualToString:VWWSegueAxisToSensitivity]){
        VWWSensitivityParameterTableViewController *vc = segue.destinationViewController;
        vc.synthesizerGroup = self.synthesizerGroup;
    }
}


#pragma mark Private methods


-(NSString*)stringFromWavetype:(VWWWaveType)waveType{

    if(waveType == VWWWaveTypeSine){
        return @"Sine wave";
    } else if(waveType == VWWWaveTypeSquare){
        return @"Square wave";
    } else if(waveType == VWWWaveTypeTriangle){
        return @"Triangle wave";
    } else if(waveType == VWWWaveTypeSawtooth){
        return @"Sawtooth wave";
    }
    return @"";
}


-(NSString*)stringFromEffectType:(VWWEffectType)effectType{
    if(effectType == VWWEffectTypeNone){
        return @"None";
    } else if(effectType == VWWEffectTypeAutoTune){
        return @"Autotune";
    }
    return @"";
    
}

-(void)updateControls{
    
    if([self.synthesizerGroup.groupType isEqualToString:VWWSynthesizerGroupTouchScreen]){
        NSString *frequencySummaryString = [NSString stringWithFormat:@"X: %.0fHz - %.0fHz\n"
                                            @"Y: %.0fHz - %.0fHz\n",
                                            self.synthesizerGroup.xSynthesizer.frequencyMin, self.synthesizerGroup.xSynthesizer.frequencyMax,
                                            self.synthesizerGroup.ySynthesizer.frequencyMin, self.synthesizerGroup.ySynthesizer.frequencyMax];
        self.frequencySummaryLabel.text = frequencySummaryString;
        
        
        NSString *waveformSummaryString = [NSString stringWithFormat:@"X: %@\n"
                                           @"Y: %@\n",
                                           [self stringFromWavetype:self.synthesizerGroup.xSynthesizer.waveType],
                                           [self stringFromWavetype:self.synthesizerGroup.ySynthesizer.waveType]];
        self.waveformSummaryLabel.text = waveformSummaryString;
        
        
        NSString *amplitudeSummaryString = [NSString stringWithFormat:@"X: %ld%%\n"
                                            @"Y: %ld%%\n",
                                            (long)(self.synthesizerGroup.xSynthesizer.amplitude * 100.0),
                                            (long)(self.synthesizerGroup.ySynthesizer.amplitude * 100.0)];
        self.amplitudeSummaryLabel.text = amplitudeSummaryString;
        
        
        NSMutableString *xEffectString = [[self stringFromEffectType:self.synthesizerGroup.xSynthesizer.effectType] mutableCopy];
        if(self.synthesizerGroup.xSynthesizer.effectType == VWWEffectTypeAutoTune){
            [xEffectString appendFormat:@" (%@)", [VWWSynthesizerTypes stringFromKey:self.synthesizerGroup.xSynthesizer.keyType]];
        }
        
        NSMutableString *yEffectString = [[self stringFromEffectType:self.synthesizerGroup.ySynthesizer.effectType] mutableCopy];
        if(self.synthesizerGroup.ySynthesizer.effectType == VWWEffectTypeAutoTune){
            [yEffectString appendFormat:@" (%@)", [VWWSynthesizerTypes stringFromKey:self.synthesizerGroup.ySynthesizer.keyType]];
        }
        
        
        
        NSString *effectSummaryString = [NSString stringWithFormat:@"X: %@\n"
                                         @"Y: %@\n",
                                         xEffectString,
                                         yEffectString];
        self.effectSummaryLabel.text = effectSummaryString;

    } else if([self.synthesizerGroup.groupType isEqualToString:VWWSynthesizerGroupMotion]){
        NSString *frequencySummaryString = [NSString stringWithFormat:@"X: %.0fHz - %.0fHz\n"
                                            @"Y: %.0fHz - %.0fHz\n"
                                            @"Z: %.0fHz - %.0fHz",
                                            self.synthesizerGroup.xSynthesizer.frequencyMin, self.synthesizerGroup.xSynthesizer.frequencyMax,
                                            self.synthesizerGroup.ySynthesizer.frequencyMin, self.synthesizerGroup.ySynthesizer.frequencyMax,
                                            self.synthesizerGroup.zSynthesizer.frequencyMin, self.synthesizerGroup.zSynthesizer.frequencyMax];
        self.frequencySummaryLabel.text = frequencySummaryString;
        
        
        NSString *waveformSummaryString = [NSString stringWithFormat:@"X: %@\n"
                                           @"Y: %@\n"
                                           @"Z: %@",
                                           [self stringFromWavetype:self.synthesizerGroup.xSynthesizer.waveType],
                                           [self stringFromWavetype:self.synthesizerGroup.ySynthesizer.waveType],
                                           [self stringFromWavetype:self.synthesizerGroup.zSynthesizer.waveType]];
        self.waveformSummaryLabel.text = waveformSummaryString;
        
        
        NSString *amplitudeSummaryString = [NSString stringWithFormat:@"X: %ld%%\n"
                                            @"Y: %ld%%\n"
                                            @"Z: %ld%%",
                                            (long)(self.synthesizerGroup.xSynthesizer.amplitude * 100.0),
                                            (long)(self.synthesizerGroup.ySynthesizer.amplitude * 100.0),
                                            (long)(self.synthesizerGroup.zSynthesizer.amplitude * 100.0)];
        self.amplitudeSummaryLabel.text = amplitudeSummaryString;
        
        
        NSMutableString *xEffectString = [[self stringFromEffectType:self.synthesizerGroup.xSynthesizer.effectType] mutableCopy];
        if(self.synthesizerGroup.xSynthesizer.effectType == VWWEffectTypeAutoTune){
            [xEffectString appendFormat:@" (%@)", [VWWSynthesizerTypes stringFromKey:self.synthesizerGroup.xSynthesizer.keyType]];
        }
        
        NSMutableString *yEffectString = [[self stringFromEffectType:self.synthesizerGroup.ySynthesizer.effectType] mutableCopy];
        if(self.synthesizerGroup.ySynthesizer.effectType == VWWEffectTypeAutoTune){
            [yEffectString appendFormat:@" (%@)", [VWWSynthesizerTypes stringFromKey:self.synthesizerGroup.ySynthesizer.keyType]];
        }
        
        NSMutableString *zEffectString = [[self stringFromEffectType:self.synthesizerGroup.zSynthesizer.effectType] mutableCopy];
        if(self.synthesizerGroup.zSynthesizer.effectType == VWWEffectTypeAutoTune){
            [zEffectString appendFormat:@" (%@)", [VWWSynthesizerTypes stringFromKey:self.synthesizerGroup.zSynthesizer.keyType]];
        }
        
        
        NSString *effectSummaryString = [NSString stringWithFormat:@"X: %@\n"
                                         @"Y: %@\n"
                                         @"Z: %@",
                                         xEffectString,
                                         yEffectString,
                                         zEffectString];
        self.effectSummaryLabel.text = effectSummaryString;

    } else if([self.synthesizerGroup.groupType isEqualToString:VWWSynthesizerGroupCamera]){
        NSString *frequencySummaryString = [NSString stringWithFormat:@"R: %.0fHz - %.0fHz\n"
                                            @"G: %.0fHz - %.0fHz\n"
                                            @"B: %.0fHz - %.0fHz",
                                            self.synthesizerGroup.xSynthesizer.frequencyMin, self.synthesizerGroup.xSynthesizer.frequencyMax,
                                            self.synthesizerGroup.ySynthesizer.frequencyMin, self.synthesizerGroup.ySynthesizer.frequencyMax,
                                            self.synthesizerGroup.zSynthesizer.frequencyMin, self.synthesizerGroup.zSynthesizer.frequencyMax];
        self.frequencySummaryLabel.text = frequencySummaryString;
        
        
        NSString *waveformSummaryString = [NSString stringWithFormat:@"R: %@\n"
                                           @"G: %@\n"
                                           @"B: %@",
                                           [self stringFromWavetype:self.synthesizerGroup.xSynthesizer.waveType],
                                           [self stringFromWavetype:self.synthesizerGroup.ySynthesizer.waveType],
                                           [self stringFromWavetype:self.synthesizerGroup.zSynthesizer.waveType]];
        self.waveformSummaryLabel.text = waveformSummaryString;
        
        
        NSString *amplitudeSummaryString = [NSString stringWithFormat:@"R: %ld%%\n"
                                            @"G: %ld%%\n"
                                            @"B: %ld%%",
                                            (long)(self.synthesizerGroup.xSynthesizer.amplitude * 100.0),
                                            (long)(self.synthesizerGroup.ySynthesizer.amplitude * 100.0),
                                            (long)(self.synthesizerGroup.zSynthesizer.amplitude * 100.0)];
        self.amplitudeSummaryLabel.text = amplitudeSummaryString;
        
        
        NSMutableString *xEffectString = [[self stringFromEffectType:self.synthesizerGroup.xSynthesizer.effectType] mutableCopy];
        if(self.synthesizerGroup.xSynthesizer.effectType == VWWEffectTypeAutoTune){
            [xEffectString appendFormat:@" (%@)", [VWWSynthesizerTypes stringFromKey:self.synthesizerGroup.xSynthesizer.keyType]];
        }
        
        NSMutableString *yEffectString = [[self stringFromEffectType:self.synthesizerGroup.ySynthesizer.effectType] mutableCopy];
        if(self.synthesizerGroup.ySynthesizer.effectType == VWWEffectTypeAutoTune){
            [yEffectString appendFormat:@" (%@)", [VWWSynthesizerTypes stringFromKey:self.synthesizerGroup.ySynthesizer.keyType]];
        }
        
        NSMutableString *zEffectString = [[self stringFromEffectType:self.synthesizerGroup.zSynthesizer.effectType] mutableCopy];
        if(self.synthesizerGroup.zSynthesizer.effectType == VWWEffectTypeAutoTune){
            [zEffectString appendFormat:@" (%@)", [VWWSynthesizerTypes stringFromKey:self.synthesizerGroup.zSynthesizer.keyType]];
        }
        
        
        NSString *effectSummaryString = [NSString stringWithFormat:@"R: %@\n"
                                         @"G: %@\n"
                                         @"B: %@",
                                         xEffectString,
                                         yEffectString,
                                         zEffectString];
        self.effectSummaryLabel.text = effectSummaryString;

    }
    

}

#pragma mark IBActions
- (IBAction)doneButtonAction:(id)sender {
    [[VWWSynthesizersController sharedInstance] writeSettings];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row == VWWSynthesizerAxisFrequencyRow){
        [self performSegueWithIdentifier:VWWSegueAxisToFrequency sender:self];
    } else if(indexPath.row == VWWSynthesizerAxisWaveformRow){
        [self performSegueWithIdentifier:VWWSegueAxisToWaveform sender:self];
    } else if(indexPath.row == VWWSynthesizerAxisAmplitudeRow){
        [self performSegueWithIdentifier:VWWSegueAxisToAmplitude sender:self];
    } else if(indexPath.row == VWWSynthesizerAxisEffectRow){
        [self performSegueWithIdentifier:VWWSegueAxisToEffect sender:self];
    } else if(indexPath.row == VWWSynthesizerAxisSensitivityRow){
        [self performSegueWithIdentifier:VWWSegueAxisToSensitivity sender:self];
    }
    
    
}
@end
