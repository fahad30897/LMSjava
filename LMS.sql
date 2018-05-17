
create table Address(
    addressId serial primary key,
    city varchar(50) not null,
    state varchar(50) not null,
    country varchar(50) not null,
    area varchar(50) not null,
    description varchar(200),
    pincode bigint not null
);


create table Institute(
    instituteId serial primary key,
    name varchar(50) not null,
    contactno varchar(20) not null,
    description varchar(200),
    registered boolean DEFAULT false,
    addressId integer REFERENCES Address(addressId)
);

create table Course(
    courseId serial primary key,
    name varchar(50) not null,
    durationHours integer not null,
    description varchar(200),
    registered boolean DEFAULT false
);


create table Batch(
    batchId serial primary key,
    name varchar(50) not null,
    startDate timestamp not null,
    remarks varchar(200),
    courseId integer references Course(courseId) ,
    Institute integer references Institute(instituteId) 
);


create table Topic(
    topicId serial primary key,
    name varchar(50) not null,
    parentTopicId integer references Topic(topicId) ,
    description varchar(200),
    registered boolean DEFAULT false
);


create table Plan(
    planId integer primary key,
    name varchar(50) not null,
    description varchar(200),
    noOfInstituteAuthority integer not null,
    noOfInstituteSME integer not null,
    noOfReceptionist integer not null,
    noOfMarketeer integer not null,
    noOfTrainer integer not null,
    noOfTrainee integer not null,
    price real,
    durationDays integer
);


create table InstituteCourses(
    instituteId integer references Institute(instituteId) ON DELETE CASCADE,
    courseId integer references Course(courseId) ON DELETE CASCADE,
    PRIMARY KEY (instituteId , courseId)
);


create table InstitutePlan(
    instituteId integer references Institute(instituteId) ON DELETE CASCADE,
    planId integer references Plan(planId) ON DELETE CASCADE,
    active boolean DEFAULT true,
    PRIMARY KEY (instituteId , planId)
);


create table CourseTopics(
    courseId integer references Course(courseId) ON DELETE CASCADE,
    topicId integer references Topic(topicId) ON DELETE CASCADE,
    PRIMARY KEY (courseId , topicId)
);


create table CoursePrerequisite(
    courseId integer references Course(courseId) ON DELETE CASCADE,
    prerequisiteTopicId integer references Topic(topicId) ON DELETE CASCADE,
    PRIMARY KEY (courseId , prerequisiteTopicId)  
);


create table TopicPrerequisite(
    topicId integer references Topic(topicId) ON DELETE CASCADE,
    prerequisiteTopicId integer references Topic(topicId) ON DELETE CASCADE,
    PRIMARY KEY (topicId , prerequisiteTopicId)
);


create table TopicResources(
    topicId integer references Topic(topicId) ON DELETE CASCADE,
    resource varchar(50),
    PRIMARY KEY (topicId , resource)
);


create table TopicQuestions(
    topicId integer references Topic(topicId) ON DELETE CASCADE,
    question varchar(200),
    PRIMARY KEY (topicId, question)
); 


create table Actor(
    actorId integer primary key,
    actorRole varchar(50) not null
);

create table LMSUser(
    userId serial primary key,
    username varchar(50) not null,
    password varchar(50) not null,
    email varchar(50) not null,
    fullname varchar(50),
    contactno varchar(20) not null,
    addressId integer references Address(addressId),
    actorId integer references Actor(actorId),
    registered boolean DEFAULT false
);

create table admin(
    adminId integer references LMSUser(userId),
    PRIMARY KEY (adminId)
);

create table BatchTrainee(
    traineeId integer references LMSUser(userId) ON DELETE CASCADE,
    batchId integer references Batch(batchId) ON DELETE CASCADE,
    enrolled boolean DEFAULT false,
    PRIMARY KEY (traineeId, batchId)
);

create table Receptionist(
    receptionistId integer references LMSUser(userId) ON DELETE CASCADE,
    instituteId integer references Institute(instituteId) ON DELETE CASCADE,
    PRIMARY KEY (receptionistId , instituteId)
);


create table InstituteAuthority(
    instituteId integer references Institute(instituteId) ON DELETE CASCADE,
    authorityId integer references LMSUser(userId) ON DELETE CASCADE,
    PRIMARY KEY (instituteId , authorityId)
);


create table Marketeer(
    instituteId integer references Institute(instituteId) ON DELETE CASCADE,
    marketeerId integer references LMSUser(userId) ON DELETE CASCADE,
    PRIMARY KEY (instituteId , marketeerId)
);


create table Trainer(
    instituteId integer references Institute(instituteId) ON DELETE CASCADE,
    trainerId integer references LMSUser(userId) ON DELETE CASCADE,
    PRIMARY KEY (instituteId , trainerId)
);


create table InstituteSMEcourses(
    instituteSMEId integer references LMSUser(userId) ON DELETE CASCADE,
    courseId integer references Course(courseId) ON DELETE CASCADE,
    PRIMARY KEY (instituteSMEId , courseId)
);

create table InstituteSME(
    instituteId integer references Institute(instituteId) ON DELETE CASCADE,
    instituteSMEId integer references LMSUser(userId) ON DELETE CASCADE,
    PRIMARY KEY (instituteId , instituteSMEId)
);

create table PortalSME(
    portalSMEId integer references LMSUser(userId) ON DELETE CASCADE,
    PRIMARY KEY (portalSMEId)
);

create table PortalSMEcourses(
    courseId integer references Course(courseId) ON DELETE CASCADE,
    portalSMEId integer references LMSUser(userId) ON DELETE CASCADE,
    PRIMARY KEY (courseId , portalSMEId)
);


create table TrainingSession(
    sessionId serial primary key,
    startTime timestamp not null,
    endTime timestamp not null,
    trainerId integer references LMSUser(userId) ON DELETE CASCADE,
    description varchar(200),
    sessionType integer not null,
    batchId integer references Batch(batchId) ON DELETE CASCADE,
    authorizationType integer DEFAULT 0
);


create table SessionAttendance(
    sessionId integer references TrainingSession(sessionId) ON DELETE CASCADE,
    traineeId integer references LMSUser(userId) ON DELETE CASCADE,
    PRIMARY KEY (sessionId , traineeId)
);


create table SessionFeedback(
    feedbackId serial primary key,
    sessionId integer references TrainingSession(sessionId) ON DELETE CASCADE,
    feedback varchar(200),
    feedbacker integer references LMSUser(userId) ON DELETE CASCADE
);


create table SessionTopics(
    sessionId integer references TrainingSession(sessionId) ON DELETE CASCADE,
    topicId integer references Topic(topicId) ON DELETE CASCADE,
    topicCoverage integer,
    PRIMARY KEY (sessionId , topicId)
);


create table LearningObjective(
    topicId integer references Topic(topicId) ON DELETE CASCADE,
    learningObjective varchar(200),
    PRIMARY KEY (topicId , learningObjective)
);
