//
//  Person+CoreDataProperties.m
//  
//
//  Created by 任鹏 on 2018/5/1.
//
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Person"];
}

@dynamic age;
@dynamic name;
@dynamic sex;
@dynamic num;

@end
