# skylynxs-react-typescript
This creates a starter image for quickly creating websites

> The project was created using the following command
```
npx create-react-app my-app --template typescript
```
> I have updated the base files to follow the patteren for all wbesites copy the entire folder to get starrted. 
> 
### **Env Config**
  - React Type Script(ejected)
    - my-app
      - webapp
    - data

## How to Use
copy the client floder should be copied when using this image bind the client folder to a local volume with readwrite

- use the dev compose while building website once built use Prod
- to create a production image
- once the production image is ready we can use awsci to copy file to s3 bucket or spin up vm with docker file
might need to run 

npm install --save-dev @types/node 
 in dev mode  
When you are ready to start

```
docker-compose -f docker-compose-dev.yml up -it
```
> To test code you need to run these command inside of the docker container
> 
```
docker-compose -f docker-compose-dev.yml up -d or

```

> to stop
>
```
docker-compose -f docker-compose-dev.yml down
```

## Test Depoly
> Here I just listed the script commands to run to process th script
> You need to manually create the silverlining network externally once:k 
>

``` bash
docker network create --driver bridge silverlining

```

## Production build
> This section will cpverthe details of how the scripts were written then the commands to run to process the script

> We will pus
## aws s3 command-

```
 aws s3 - help
```
**LocalPath**: represents the path of a local file or directory.  It can
be written as an absolute path or relative path.

**S3Uri:** represents the location of a S3 object, prefix, or bucket.
This must be written in the form "s3://mybucket/mykey" where
"mybucket" is the specified S3 bucket, "mykey" is the specified S3
key.  The path argument must begin with "s3://" in order to denote
that the path argument refers to a S3 object. Note that prefixes are
separated by forward slashes. For example, if the S3 object "myobject"
had the prefix "myprefix", the S3 key would be "myprefix/myobject",
and if the object was in the bucket "mybucket", the "S3Uri" would be
"s3://mybucket/myprefix/myobject.

Single Local File and S3 Object Operations
==========================================

>Some commands perform operations only on single files and S3 objects.
The following commands are single file/object operations if no "--
recursive" flag is provided.

    **"cp"**

   ** "mv"**

    **"rm"**
>


## Push Build

# GitHub Setup
this sections covers how to config git hub and make it work with AWS for easy publishing of the websites and servers also make sure you are using a git bash window for these commands to work. Make sure you are using the correct branch. Create a new dev branch until the first release then push new branch to trunk once we publish to server trunk branch is production branch. all dev branches are called main 

## First thing test to see you are logged in to github
``` bash
git config --global user.name
```

## Setup repo 

- Initialize Git (if not already done):
``` bash
 git init

```
- Add the remote GitHub repo:

``` bash
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/<your-username>/<your-repo>.git
git push -u origin main
```

example for this repo

``` bash
git add .
git commit -m "Initial commit Main branch"
git remote add origin https://github.com/kurickabides/skylynx-server.git
git push -u origin main
```

#GIS Model
```mermaid
flowchart TD
  %% --- Substation & Source ---
  A[Transmission Source<br/>69/115/138 kV] --> B[Substation Power Transformer<br/>69 kV → 12.47 kV]
  B --> C1[Substation Bus]
  C1 --> D1{Feeder A<br/>12.47 kV or 24.9 kV}
  C1 --> D2{Feeder B<br/>12.47 kV or 24.9 kV}

  %% --- Feeder Devices (typical sequence) ---
  D1 --> E1[Breaker/Recloser<br/>Protection]
  E1 --> E2[Sectionalizer<br/>Auto-Isolate]
  E2 --> E3[Switch Manual/Motor<br/>Tie/Normal Open]
  E3 --> E4[Voltage Regulator<br/>Boost/Buck]
  E4 --> E5[Capacitor Bank<br/>Power Factor Volt Support]

  %% --- Laterals off Feeder ---
  E3 --> L1{Lateral Tap 1<br/>Primary 12.47/24.9 kV}
  E4 --> L2{Lateral Tap 2<br/>Primary 12.47/24.9 kV}

  %% --- Lateral Protection ---
  L1 --> F1[Fuse Cutout<br/>Protect Lateral]
  L2 --> F2[Fuse Cutout<br/>Protect Lateral]

  %% --- Distribution Transformers on Laterals ---
  F1 --> T1[Dist. XFMR Pole/Pad<br/>7.2 kV L-N → 120/240 V]
  F1 --> T2[Dist. XFMR<br/>kVA Rated, Phase Assigned]
  F2 --> T3[Dist. XFMR]
  F2 --> T4[Dist. XFMR]

  %% --- Secondary & Services ---
  T1 --> S1[Secondary Conductors<br/>120/240 V, 208 V, 480 V]
  T2 --> S2[Secondary Conductors]
  T3 --> S3[Secondary Conductors]
  T4 --> S4[Secondary Conductors]

  S1 --> M1[Meters / Services]
  S2 --> M2[Meters / Services]
  S3 --> M3[Meters / Services]
  S4 --> M4[Meters / Services]

  %% --- Attachments / Joint Use (context for GIS) ---
  P1[Poles/Structures<br/>Unique IDs] --- D1
  P1 --- L1
  P1 --- L2
  P1 ---|Foreign Attachments<br/>Telco/Cable| FA[Attachment Records & Permits]

  %% --- Notes (why GIS cares) ---
  classDef note fill:#f7f7f7,stroke:#bbb,color:#333,font-size:11px;
  N1[Connectivity drives load flow, fault studies, OMS]:::note
  N2[Correct phase, device types, and locations are critical]:::note
  N3[Easements, annexations, tax codes tie to parcels/poles]:::note
  E5 --- N1
  T2 --- N2
  FA --- N3


```
## ArcMap ModelBuilder utility examples
```mermaid 
flowchart LR
    %% Title
    subgraph MB[ArcMap ModelBuilder: Feeder QA & Export Workflow]
    direction LR

    %% Inputs
    A1[Input: Feeder Feature Class]:::input
    A2[Input: Pole Feature Class]:::input
    A3[Input: Device Tables]:::input

    %% Step 1 - Select Updated Features
    B1[Select Layer By Attribute<br/>WHERE EditDate >= Today-7]:::process
    A1 --> B1

    %% Step 2 - Geometry Validation
    B2[Check Geometry<br/>Find Null Shapes / Bad Vertices]:::process
    B1 --> B2

    %% Step 3 - Attribute QA
    B3[Select By Attributes<br/>Null PhaseDesignation or PoleID]:::process
    A2 --> B3

    %% Step 4 - Connectivity QA
    B4[Select By Location<br/>Poles Not Intersecting Conductors]:::process
    B3 --> B4
    A2 --> B4

    %% Step 5 - Export QA Results
    B5[Export Selected Features<br/>to QA GDB]:::process
    B4 --> B5
    B2 --> B5

    %% Step 6 - Create Feeder Map
    B6[Clip Feeder Features<br/>to Service Area]:::process
    B1 --> B6
    B6 --> B7[Map Document → PDF Export]:::process

    %% Step 7 - Deliverables
    B7 --> C1[QA GDB for Engineering]:::output
    B7 --> C2[Feeder PDF Map for Field Crews]:::output
    B5 --> C1

    end

    %% Styles
    classDef input fill:#cce5ff,stroke:#2b6cb0,stroke-width:1px,color:#000,font-weight:bold;
    classDef process fill:#fef6e4,stroke:#d97706,stroke-width:1px,color:#000;
    classDef output fill:#d4edda,stroke:#2f855a,stroke-width:1px,color:#000,font-weight:bold;


```
# storm workflow

```mermaid

flowchart TD
  %% Storm GIS Workflow Overview
  A[Storm Watch and Prep] --> B[EOC Activation and Data Sync]
  B --> C[Live Outage Mapping and Dashboards]
  C --> D[Network Traces to Suspect Device]
  D --> E[Crew Assignment Support]
  E --> F[Damage Assessment Intake and QA]
  F --> G[Restoration Modeling and Switching Plans]
  G --> H[Status Updates to OMS and Comms]
  H --> I[Archive Event Layers and Corrections]
  I --> J[After Action Review and Data Cleanup]

  %% Data flows
  subgraph Feeds
    W[Weather Layers]
    O[OMS Trouble Calls]
    S[SCADA Device Status]
    M[AMI Meter Pings]
    R[Field Reports and GPS Photos]
  end

  W --> C
  O --> C
  S --> C
  M --> C
  R --> F


```

### gANT sTORM
```mermaid
gantt
  title Storm Day Timeline for GIS
  dateFormat HH:mm
  axisFormat %H:%M

  section Early Activation
  EOC standup and sync with OMS and SCADA        :done,    06:00, 01:00
  Load offline maps for crews                     :active,  06:30, 00:45

  section Impact Window
  Live outage intake and aggregation              :         07:30, 04:00
  Downstream and upstream traces to suspect device:         08:00, 03:30
  Crew assignment maps and grid access notes      :         08:30, 03:00

  section Damage Assessment
  Field reports ingest and QA location accuracy   :         12:00, 04:00
  Update dashboards and restoration estimates     :         12:30, 03:30
  Candidate switching plans and tie options       :         13:00, 03:00

  section Restoration Tracking
  Device status updates and map refresh           :         16:00, 03:00
  Customer counts by outage polygon               :         16:15, 02:45
  Comms exports web and print map sets            :         17:00, 02:00

  section Wrap Up
  Archive event layers and notes                  :         19:00, 01:00
  Correct GIS features flagged during response    :         19:30, 01:00
  After action packet for engineering and ops     :         20:00, 01:00


```