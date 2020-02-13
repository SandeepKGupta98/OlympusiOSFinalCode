//
//  AboutViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 03/07/19.
//  Copyright © 2019 Sandeep Kr Gupta. All rights reserved.
//

#import "AboutViewController.h"
#import "MFSideMenu.h"

@interface AboutViewController (){
    NSMutableArray *dataAry;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataAry = [[NSMutableArray alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    if (self.isIndia) {
        [self aboutOlympusIndiaData];
    }else{
        [self aboutOlympusData];
    }
    // Do any additional setup after loading the view.
}
-(void)aboutOlympusIndiaData{
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"OLYMPUS INDIA",@"data",@"mainHeadingCell",@"type", nil]];

//    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All of our activities are based on our corporate philosophy, which consists of Our Purpose and Our Core Values.",@"data",@"detailCell",@"type", nil]];
//    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Our Purpose",@"data",@"subHeadingCell",@"type", nil]];
//    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Making people's lives healthier, safer and more fulfilling",@"data",@"subHeadingCell2",@"type", nil]];
//    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Supporting cutting-edge medical procedures and scientific discoveries. Helping make people feel safer and more secure. Capturing life’s most precious moments. Through our business activities, we aim to contribute to global society by making these things happen. This is the purpose of our existence.",@"data",@"detailCell",@"type", nil]];
//
//    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image9.png",@"data",@"imageCell",@"type", nil]];
//    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Our Core Values",@"data",@"subHeadingCell",@"type", nil]];
//    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Integrity, Empathy, Long-Term View, Agility, and Unity",@"data",@"subHeadingCell2",@"type", nil]];
//    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"These values are shared among all global Olympus employees and are reflected in everything we do at Olympus. They are the very values that will let us realize Our Purpose.",@"data",@"detailCell",@"type", nil]];
//    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image10.png",@"data",@"imageCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Company Profile",@"data",@"subHeadingCell",@"type", nil]];


    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Olympus Medical Systems India Private Limited commenced its business operation in Indian market on April 1, 2010. Olympus established its direct presence to build a very strong marketing and service facilities. With better and innovative technology, Olympus looks forward to grow its foothold into the market with the growth in Indian Economy. Olympus Medical Systems India has a wide portfolio of products that are equipped with the latest innovative and superior technology.",@"data",@"detailCell",@"type", nil]];
    
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image5.png",@"data",@"imageCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Olympus deals primarily in three verticals i.e. Gastrointestinal, Respiration & Surgical divisions and contribute to the medical society with state of the art product categories that includes, Video Endoscopy, Endoscopic Ultrasound, Bronchoscopy, Endotherapy devices in Gastrointestinal & Respiratory range whereas Surgical division includes High definition imaging system and Energy products to deal with Laparoscopy, General Surgery, Gynecology and Urology field.",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image6.jpg",@"data",@"imageCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Olympus has made an aggressive investment in meeting global standard of after sales services in India and is committed to offer quality and time bond services to each customer through best of the jigs & tools under the most standardized protocols practiced internationally within Olympus group. Olympus has developed a strong pool of qualified engineers to offer direct services to all the customers through a regular and rigorous training in order to have quality and effective after sales services in India. Olympus understand the geography and wide spread of customers base in India and is expanding its service base in all directions through a well-established service centres and resident Field Service Engineers to work very closely with all our customers.",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image7.jpg",@"data",@"imageCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Olympus has always been keen to promote an appropriate use of all the products and got involved into conducting various training program on a regular basis. The Nurses and Technician Training program is one of its kind, where Nurses and technicians are trained on right ways of cleaning, disinfection & sterilization of endoscopy system and are informed about an appropriate use of Endotherapy accessories to enhance the life of endoscopy system with minimum repair requirements. The Training programs are held regularly in different cities and the training is imparted by the well qualified trainers and some senior speaker's. Olympus has always been a leader in the market for its innovative technologies, thus helping the society with the best in class quality, vast after sales services network to create a great value for money for each user in India.",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image8.png",@"data",@"imageCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"\n\nFor more information about our company, please visit our company website",@"data",@"subHeadingCell2",@"type", nil]];

}


-(void)aboutOlympusData{
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"OLYMPUS",@"data",@"mainHeadingCell",@"type", nil]];
    
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All of our activities are based on our corporate philosophy, which consists of Our Purpose and Our Core Values.",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Our Purpose",@"data",@"subHeadingCell",@"type", nil]];
    
    
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Making people's lives healthier, safer and more fulfilling",@"data",@"subHeadingCell2",@"type", nil]];
    
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Supporting cutting-edge medical procedures and scientific discoveries. Helping make people feel safer and more secure. Capturing life’s most precious moments. Through our business activities, we aim to contribute to global society by making these things happen. This is the purpose of our existence.",@"data",@"detailCell",@"type", nil]];
    
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image9.png",@"data",@"imageCell",@"type", nil]];

    
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Our Core Values",@"data",@"subHeadingCell",@"type", nil]];
    
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Integrity, Empathy, Long-Term View, Agility, and Unity",@"data",@"subHeadingCell2",@"type", nil]];
    
    
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"These values are shared among all global Olympus employees and are reflected in everything we do at Olympus. They are the very values that will let us realize Our Purpose.",@"data",@"detailCell",@"type", nil]];
    
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image10.png",@"data",@"imageCell",@"type", nil]];

    
    
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Company Profile",@"data",@"subHeadingCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"This year, Olympus celebrates 100 years of making people’s healthier, safer and more fulfilling around the world. Olympus was founded on October 12, 1919 as Takachiho Seisakusho. The founder of the company, Takeshi Yamashita, established the company with the financial assistance of his previous employer, with a view to achieving domestic production of microscopes.\n\nIn June 1920, just six months after the company's founding, Yamashita's dream of making a domestic microscope came true with the introduction of the Asahi, the first microscope.",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image4.jpg",@"data",@"imageCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manufactured by Takachiho.",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Three decades later, Olympus successfully developed the world's first gastrocamera for practical use. The spirit of creation that infused the company at its founding has been passed on through the years, from the release of the company's first product to its breakthroughs in Opto-Digital Technology today. In Greek mythology, Mt.Olympus is the home of the twelve supreme gods and goddesses. Olympus was named after this mountain to reflect its strong aspiration to create high quality, world famous products.",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"\"Business to Specialist\" Company",@"data",@"subHeadingCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Olympus defines a \"Business to Specialist\" Company as a company that can accurately understand the demands and unmet needs of highly specialized experts and aspirational customers (specialist) and respond by proposing and providing compelling solutions in a timely manner. Over the years, Olympus has continued to exercise its strengths as a \"Business to Specialist\" Company to grow by earning the trust of customers.",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Going forward, we will continue to utilize these strengths as we seek to become an even-more valuable partner to our customers by calling upon our innovative thinking, expertise in advancing technology, operational excellence, and unsurpassed integrity.",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Medical Business",@"data",@"subHeadingCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"At Olympus, we work with health care professionals every day, matching our innovative capabilities in medical technology and precision manufacturing with their skills to provide the best possible outcomes for patients and society. As the healthcare industry focuses on early detection of diseases and minimally invasive procedures, Olympus is there to deliver the diagnostic and therapeutic technologies they need to treat their patients.",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Business Lines",@"data",@"subHeadingCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Endoscopes",@"data",@"subHeadingCell2",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image1.jpg",@"data",@"imageCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Video endoscopy systems, gastrointestinal endoscopes, colono endoscopes, duodeno endoscopes, broncho endoscopes, ultrasound endoscopy systems: ultrasound endoscopes and probes, endoscopic ultrasound observation devices, capsule endoscope systems, reprocessing products for cleaning, disinfection and sterilization (CDS) of endoscopy equipment, integrated documentation system for capturing information relevant to endoscopy, therapeutic equipment, and other ancillary equipment.",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Endosurgery",@"data",@"subHeadingCell2",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image2.jpg",@"data",@"imageCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Endoscopy products for gastrointestinal surgery, bronchial surgery, urology, gynecology, orthopedic surgery, neurosurgery, anesthesiology, ENT (Ear, Nose, and Throat) endoscope products, therapeutic and surgical equipment, and surgical endoscope ancillary equipment.",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Endotherapy",@"data",@"subHeadingCell2",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image3.jpg",@"data",@"imageCell",@"type", nil]];
//    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Endotherapy devices",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"One Olympus",@"data",@"subHeadingCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"We will maximize performance of the entire Olympus Group by sharing values and strategies and making full use of the management resources on a global and Groupwide basis.",@"data",@"detailCell",@"type", nil]];
    [dataAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"\n\nFor more information about our company, please visit our company website",@"data",@"subHeadingCell2",@"type", nil]];


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *type = [[dataAry objectAtIndex: indexPath.row] valueForKey:@"type"];
     if([type isEqualToString:@"imageCell"] ){
         return 300;
     }
    return UITableViewAutomaticDimension;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *type = [[dataAry objectAtIndex: indexPath.row] valueForKey:@"type"];
    if ([type isEqualToString:@"mainHeadingCell"]) {
        MainHeadingCell *cell = [tableView dequeueReusableCellWithIdentifier:type];
        if (cell == nil) {
            cell = [[MainHeadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type];
        }
        cell.lbl.text = [[dataAry objectAtIndex: indexPath.row] valueForKey:@"data"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([type isEqualToString:@"detailCell"] ){
        DetailsHeadingCell *cell = [tableView dequeueReusableCellWithIdentifier:type];
        if (cell == nil) {
            cell = [[DetailsHeadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type];
        }
        cell.detailLbl.text = [[dataAry objectAtIndex: indexPath.row] valueForKey:@"data"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([type isEqualToString:@"imageCell"] ){
        ImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        if (cell == nil) {
            cell = [[ImagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
        }
        cell.imagView.image = [UIImage imageNamed:[[dataAry objectAtIndex: indexPath.row] valueForKey:@"data"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([type isEqualToString:@"subHeadingCell"] ){
        SubHeadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subHeadingCell"];
        if (cell == nil) {
            cell = [[SubHeadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subHeadingCell"];
        }
        cell.headingLbl.text = [[dataAry objectAtIndex: indexPath.row] valueForKey:@"data"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([type isEqualToString:@"subHeadingCell2"] ){
        SubHeadingCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"subHeadingCell2"];
        if (cell == nil) {
            cell = [[SubHeadingCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subHeadingCell2"];
        }
        cell.headingLbl2.text = [[dataAry objectAtIndex: indexPath.row] valueForKey:@"data"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        DetailsHeadingCell *cell = [tableView dequeueReusableCellWithIdentifier:type];
        if (cell == nil) {
            cell = [[DetailsHeadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type];
        }
        cell.detailLbl.text = [[dataAry objectAtIndex: indexPath.row] valueForKey:@"data"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    

}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataAry.count;
}


- (IBAction)menuButtonTapped:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (IBAction)moreInfoTapped:(id)sender {
    NSString *url;
    if (self.isIndia) {
        url = @"http://olympusmedical.co.in/";
    }else{
        url = @"https://www.olympus-global.com/";
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    
}
@end

@implementation MainHeadingCell
-(void)awakeFromNib{
    [super awakeFromNib];
}
@end

@implementation SubHeadingCell
-(void)awakeFromNib{
    [super awakeFromNib];
}
@end
@implementation SubHeadingCell2
-(void)awakeFromNib{
    [super awakeFromNib];
}
@end



@implementation DetailsHeadingCell
-(void)awakeFromNib{
    [super awakeFromNib];
}
@end

@implementation ImagesCell
-(void)awakeFromNib{
    [super awakeFromNib];
}
@end
