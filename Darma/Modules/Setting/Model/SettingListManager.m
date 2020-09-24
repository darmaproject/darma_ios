



#import "SettingListManager.h"

#import "SettingModel.h"

@implementation SettingListManager
-(NSMutableArray *)item{
    if (!_item) {
        _item=[NSMutableArray array];
        
        NSMutableArray *list = [NSMutableArray array];
        [list addObject:@[@{@"titleName": BITLocalizedCapString(@"Current node", nil), @"pushClass" : @"NodeViewController", @"iconName" : @"", @"rightType" : @1},
                          @{@"titleName": BITLocalizedCapString(@"Sync interval", nil), @"pushClass" : @"SyncIntervalViewController", @"iconName" : @"", @"rightType" : @1}]];
        
        [list addObject:@[@{@"titleName": BITLocalizedCapString(@"Change password", nil), @"pushClass" : @"ChangePasswordViewController", @"iconName" : @"", @"rightType" : @1},
                          @{@"titleName": BITLocalizedCapString(@"Rescan Blockchain", nil), @"pushClass" : @"InitialHightSyncViewController", @"iconName" : @"", @"rightType" : @1},
                          @{@"titleName": BITLocalizedCapString(@"Show keys", nil), @"pushClass" : @"PrivateKeysViewController", @"iconName" : @"", @"rightType" : @1},
                          @{@"titleName": BITLocalizedCapString(@"Show seed", nil), @"pushClass" : @"MnemoicWordViewController", @"iconName" : @"", @"rightType" : @1}]];
        
        [list addObject:@[@{@"titleName": BITLocalizedCapString(@"Select Language", nil), @"pushClass" : @"BITSettingChangePhoneController", @"iconName" : @"", @"rightType" : @1},
                          @{@"titleName": BITLocalizedCapString(@"Finger/Face/Gesture", nil), @"pushClass" : @"BITChangeEmailController", @"iconName" : @"", @"rightType" : @1}]];
        [list addObject:@[@{@"titleName": BITLocalizedCapString(@"Backup Wallet", nil), @"pushClass" : @"", @"iconName" : @"", @"rightType" : @1}]];
        
        [list addObject:@[@{@"titleName": BITLocalizedCapString(@"Privacy Policy", nil), @"pushClass" : @"AgreementViewController", @"iconName" : @"", @"rightType" : @1}]];
         NSMutableArray *modesArray = [NSMutableArray array];
        for (NSArray *array in list)
        {
            [modesArray addObject:[SettingModel mj_objectArrayWithKeyValuesArray:array]];
        }
        
        BOOL isTouchID=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenUnlock"];
        NSString* GesPass=[[NSUserDefaults standardUserDefaults] objectForKey:@"isSetGesPass"];
        
        for (int i=0; i<modesArray.count; i++)
        {
            NSArray *array = modesArray[i];
            NSMutableArray *data = [NSMutableArray array];
            for (SettingModel *model in array)
            {
                if ([model.titleName isEqualToString:BITLocalizedCapString(@"Current node", nil)])
                {
                    NSMutableArray *nodes= [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:nodeKey]];
                    for (int i=0; i<nodes.count; i++) {
                        NSDictionary *selectDict=[[NSMutableDictionary alloc] initWithDictionary:nodes[i]];
                        NSString *isSelect=[NSString stringWithFormat:@"%@",selectDict[@"isSelect"]];
                        if ([isSelect isEqualToString:@"1"]) {
                            NSArray *nodes=[selectDict[@"node"] componentsSeparatedByString:@","];
                            if (nodes.count>1) {
                                model.desc =BITLocalizedCapString(@"Auto", nil);
                            }else{
                                model.desc = selectDict[@"node"];
                            }
                           
                        }
                    }
                    
                }
                else if ([model.titleName isEqualToString:BITLocalizedCapString(@"Finger/Face/Gesture", nil)]){
                    if (isTouchID) {
                        model.desc = BITLocalizedCapString(@"Enable", nil);
                    } else{
                        if (GesPass && GesPass.length != 0) {
                            BOOL isOn=[[NSUserDefaults standardUserDefaults] boolForKey:@"isOnGesPass"];
                            if(isOn){
                                  model.desc = BITLocalizedCapString(@"Enable", nil);
                            }else{
                                model.desc = BITLocalizedCapString(@"disabled", nil);
                            }
                        }else{
                            model.desc = BITLocalizedCapString(@"disabled", nil);
                        }
                    }
                }
                
                [data addObject:model];
            }
            if (data.count > 0)
            {
                [_item addObject:data];
            }
        }
       
       
        
    }
    return _item;
}
@end
