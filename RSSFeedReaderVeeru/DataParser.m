//
//  DataParser.m
//  RSSFeedReaderVeeru
//
//  Created by veerababu mulugu on 9/27/16.
//  Copyright © 2016 veerababu m. All rights reserved.
//

#import "DataParser.h"
#import "FeedBO.h"

@interface DataParser () <NSXMLParserDelegate>


@property (nonatomic, strong) NSString *strElement;
@property (nonatomic, strong) NSMutableString *strTitle;
@property (nonatomic, strong) NSMutableString *strDescription;
@property (nonatomic, strong) NSMutableString *strImageURL;
@property (nonatomic, strong) NSMutableString *strDate;
@property (nonatomic, strong) NSMutableString *strFeedURL;

@property (nonatomic, strong) NSXMLParser *parser;

@end

@implementation DataParser

-(id)init {
    self = [super init];
    if(self != nil) {
        self.arrFeedBO = [NSMutableArray array];
    }
    return self;
}

-(void)parseDataWithCompletion:(SuccessCompletionBlock)completionHandler {
    
    if(!self.parser) {
        self.parser = [[NSXMLParser alloc] initWithData:self.data];
    }
    self.parser.delegate = self;
    BOOL isParsing = [self.parser parse];
    if(isParsing) {
        [self.reference downloadImagesForFeed:self.arrFeedBO competionHandler:^(NSMutableArray *array) {
            self.arrFeedBO = array;
            completionHandler(YES);
        }];
    }
    else {
        completionHandler(NO);
    }

}


-(NSString *)stringByStrippingHTML:(NSString *)givenString {
    
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"<[^>]+>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *strResult = [regExp stringByReplacingMatchesInString:givenString options:NSMatchingReportCompletion range:NSMakeRange(0, givenString.length) withTemplate:@""];
    
    return strResult;
    
//    NSRange r;
//    NSString *s = [givenString copy];
//    while ((r = [s rangeOfString:@"<[^>]*>" options:NSRegularExpressionSearch]).location != NSNotFound)
//        s = [s stringByReplacingCharactersInRange:r withString:@""];
//    
//    return s;
}

-(NSString *)getImageLink:(NSString *)givenString {
    
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"<img src=[^>]+>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *arrResults = [regExp matchesInString:givenString options:NSMatchingReportCompletion range:NSMakeRange(0, givenString.length)];
    NSTextCheckingResult *match = arrResults.firstObject;
    
    NSString *strTemp = givenString;
    NSString *imageTag = [strTemp substringWithRange:match.range];
    
    NSRegularExpression *imgRegExp = [NSRegularExpression regularExpressionWithPattern:@"\"//(.*?)\"" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *arrImageResults = [imgRegExp matchesInString:imageTag options:NSMatchingReportCompletion range:NSMakeRange(0, imageTag.length)];
    NSTextCheckingResult *imgMatch = arrImageResults.firstObject;

    NSString *strImageTemp = imageTag;
    NSString *strImageURL = [@"http:" stringByAppendingString:[[strImageTemp substringWithRange:imgMatch.range] stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
    return strImageURL;

}

-(NSDate *)dateFromString:(NSString *)givenString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
    NSDate *formattedDate = [dateFormatter dateFromString:givenString];
    return formattedDate;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    
    self.strElement = elementName;
    
    if([self.strElement isEqualToString:@"item"]) {
        self.strTitle = [NSMutableString stringWithString:@""];
        self.strDescription = [NSMutableString stringWithString:@""];
        self.strImageURL = [NSMutableString stringWithString:@""];
        self.strDate = [NSMutableString stringWithString:@""];
        self.strFeedURL = [NSMutableString stringWithString:@""];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
//    NSLog(@"string: %@",string);
    
    if([self.strElement isEqualToString:@"title"]) {
        [self.strTitle appendString:string];
    }
    else if ([self.strElement isEqualToString:@"description"]) {
        [self.strDescription appendString:string];
    }
    else if ([self.strElement isEqualToString:@"link"]) {
        [self.strFeedURL appendString:string];
    }
    else if ([self.strElement isEqualToString:@"pubDate"]) {
        [self.strDate appendString:string];
    }
    else {
        
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName {
    
    if([elementName isEqualToString:@"item"]) {
        FeedBO *feedBO = [[FeedBO alloc] init];
        feedBO.strTitle = self.strTitle;
        feedBO.strDescription = [self stringByStrippingHTML:self.strDescription];
        feedBO.strImageURL = [self getImageLink:self.strDescription];
        feedBO.image = nil;
        feedBO.date = [self dateFromString:self.strDate];
        feedBO.strFeedURL = self.strFeedURL;
        
        [self.arrFeedBO addObject:feedBO];
    }
}

@end
