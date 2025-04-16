---
icon: gear
cover: ../../.gitbook/assets/SigDisproDashboardScreenshot.png
coverY: 308.90666666666664
layout:
  cover:
    visible: false
    size: full
  title:
    visible: true
  description:
    visible: false
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
---

# Setup Guide

{% hint style="danger" %}
**Privacy Notice:** When using this report, be aware that it is not intended to be public facing, as it contains PII and small cell sizes that may allow students to be identified.
{% endhint %}

***

### Prerequisites

* [x] This report requires states to be users of **Generate** or a **CEDS Data Warehouse.**
* [x] Three years of data migrated into Generate for EDPass Files:
  * FS052 – Membership
  * FS002 – Children with Disabilities (School Age)
  * FS006 – Students with Disabilities (IDEA) Suspensions/Expulsions
  * FS143 – Children with Disabilities (IDEA) Total Disciplinary Removals
* [x] The latest version of Power BI Desktop
* [x] Access to the CEDS Data Warehouse
* [x] VPN Access if required

### Preparing CEDS Data Warehouse

The Significant Disproportionality report uses stored views of data in the Reporting Tables. These views are not standard but can be added to your instance of Generate’s semantic layer easily. This process does not require any server backups.

Generate Significant Disproportionality views were developed to represent the data used for Child Count, Membership, Placement, and Discipline data in C006 and C143 IDEA reports. These files were developed using Generate 12.3 released in early 2025 and they use the same logic for returning the IDEA submission report results. The views contain fact and dimension table ids that are joined with other fact and dimension tables within the data warehouse to return other data elements used within the BI report.

#### **The Required views are:**

{% tabs %}
{% tab title="Membership" %}
```sql
vwSignificantDisproportionality_Membership
```

**Description:** All students that are enrolled in a school for the report year, are in grades ungraded, 'AE', and PK through 12 and are between the ages 3-21

**Fields Returned:**

* Fact.FactK12StudentCountId
* Fact.K12StudentId
* Fact.SchoolYearId
* Fact.LeaId
* LEAs.LeaIdentifierSea
* LEAs.LeaIdentifierNces
* Fact.RaceId
* Fact.IdeaStatusId
* Fact.GradeLevelId
* Fact.AgeId
* 1 AS MembershipStudentCount
{% endtab %}

{% tab title="ChildCount" %}
```
vwSignificantDisproportionality_ChildCount
```

**Description:** All IDEA students that are enrolled in a school for the report year, and are between the ages 3-21

**Fields Returned:**

* Fact.FactK12StudentCountId
* Fact.PrimaryDisabilityTypeID
* Fact.K12StudentId
* Fact.SchoolYearId
* Fact.LeaId
* LEAs.LeaIdentifierSea
* LEAs.LeaIdentifierNces
* Fact.RaceId
* Fact.IdeaStatusId
* Fact.GradeLevelId
* Fact.AgeId
* 1 AS ChildCountStudentCount
{% endtab %}

{% tab title="C006" %}
```
vwSignificantDisproportionality_C006
```

**Description:** Aggregated counts of IDEA students that are not parentally placed in private school, and Idea Interim Removal EDFactsCode is not REMDW (removal for drugs, weapons, or serious bodily injury) or REMHO (removed based on a Hearing Officer finding), and are between the ages 3-21

**Fields Returned:**

* K12StudentId
* PrimaryDisabilityTypeId
* SchoolYearId
* LeaId
* RaceId
* LeaIdentifierSea
* LeaIdentifierNces
* IdeaStatusId
* GradeLevelId
* AgeId
* INSCHOOL\_LTOREQ10 (In school removal length less than or equal 10)
* INSCHOOL\_GREATER10 (In school removal length greater than 10)
* OUTOFSCHOOL\_LTOREQ10 (Out of school removal length less than or equal 10)
* OUTOFSCHOOL\_GREATER10 (Out of school removal length greater than 10)
{% endtab %}

{% tab title="C143" %}
```
vwSignificantDisproportionality_C143
```

**Description:** Aggregated counts of IDEA students that are not parentally placed in private school, has a disciplinary action taken is either expulsion with services or expulsion without services, individual duration of disciplinary action is greater or equal to 0.5, and they are between the ages 3-21

**Fields Returned:**

* SchoolYearId
* LeaId
* RaceId
* LeaIdentifierSea
* LeaIdentifierNces
* DisciplineCount (Aggregated count)
{% endtab %}

{% tab title="StudentDetails" %}
```
vwSignificantDisproportionality_C143_StudentDetails
```

**Description:** All students that are included in the view vwSignificantDisproportionality\_C143

**Fields Returned:**

* K12StudentId
* SchoolYearId
* LeaId
* RaceId
* LeaIdentifierSea
* LeaIdentifierNces
* DisciplineCount (Aggregated count by student)
{% endtab %}

{% tab title="Placement" %}
```
vwSignificantDisproportionality_Placement
```

**Description:** All IDEA students by Idea Educational Environment

**Fields Returned:**

* K12StudentId
* SchoolYearId
* RaceId
* GradeLevelId
* LeaIdentifierSea
* PrimaryDisabilityTypeID
* IdeaEducationalEnvironmentForSchoolAgeCode
* IdeaEducationalEnvironmentForSchoolAgeDescription
{% endtab %}
{% endtabs %}

#### Adding the Views

1. Save the provided script views.&#x20;

{% code title="" %}
```git
git clone https://github.com/CEDS-Collaborative-Exchange/CIID-Reports.git
```
{% endcode %}

{% @github-files/github-code-block url="https://github.com/CEDS-Collaborative-Exchange/CIID-Reports/tree/5bad8914cec558ab7428bad9fd0aab8f962b03a6/significant-disproportionality/SQL%20Views" %}



1. Open SQL Management Studio (or similar tool).
2. Execute the script to add the views to your data warehouse.
3. If changes are made to field names or values, update the BI tool accordingly.

{% hint style="info" %}
The logic in these views may need to be changed if the reporting requirements change for how child count, placement, or reports 006 and 143.
{% endhint %}

***

### Connecting the report to the source

{% hint style="success" %}
Remember to connect to the VPN if required by your network administrators.
{% endhint %}

1. Download the .pbix file from [CEDS Collaborative Exchange’s GitHub folder](https://github.com/CEDS-Collaborative-Exchange/CIID-Reports).

{% @github-files/github-code-block url="https://github.com/CEDS-Collaborative-Exchange/CIID-Reports/raw/5bad8914cec558ab7428bad9fd0aab8f962b03a6/significant-disproportionality/Significant%20Disproportionality%20Report.pbix" fullWidth="false" %}



{% hint style="info" %}
The downloaded report contains cached test data. This test data was created by CIID for this report's production and is not intended to represent any actual state data.&#x20;
{% endhint %}

2. Open the .pbix file in Power BI Desktop.
3. Click "**Transform Data**" in the home ribbon, then select "**Transform Data**" again to open Power Query.

<figure><img src="../../.gitbook/assets/SigDispro_Guide_Transform_Data.png" alt="Screenshot of the Power Query interface in Microsoft Excel showing a list of expanded queries categorized under folders named Identification Tables, Discipline Tables, Placement Tables, and Reference Table Tables. Red arrows point to each folder indicating the need to connect these tables to a CEDS Data Warehouse for accurate report sourcing."><figcaption><p>Navigating Power Query in Excel for Data Transformation</p></figcaption></figure>

4. In Power Query, the queries contain a list of tables and report measures essential to the report. Each table needs to be pointed to your CEDS Data Warehouse to ensure that the correct source data is used for the report. This includes each of the queries in the following folders:
   * Identification Tables
   * Discipline Tables
   * Placement Tables
   * Reference Table Tables

<div data-full-width="false"><figure><img src="../../.gitbook/assets/SigDispro_Setup_Reference_Tables.png" alt="Screenshot of the Power Query interface in Microsoft Excel. The image shows expanded query folders named ‘Identification Tables’, ‘Discipline Tables’, ‘Placement Tables’, and ‘Reference Table Tables’. Red arrows emphasize the need to link these tables to a CEDS Data Warehouse for accurate report data sourcing."><figcaption><p>Connecting Power Query Tables to CEDS Data Warehouse</p></figcaption></figure></div>

5. Click on each table, and then select the advanced editor.

<figure><img src="../../.gitbook/assets/SigDispro_Setup_Advanced_Editor.png" alt="A screenshot of a data management software interface. The user is instructed to click on each table and then select the ‘Advanced Editor’ option. Tables listed include ‘RDS ChildCount’, ‘RDS Membership’, and others." width="320"><figcaption><p>Accessing the Advanced Editor for table customization.</p></figcaption></figure>

6. Update each table's IP Address and Database name in the Advanced Editor. Tables to Update:
   * RDS ChildCount
   * RDS Membership
   * RDS.Placement
   * RDS.ChildCount\_C006
   * RDS ChildCount\_C143
   * RDS DimLeas
   * RDS DimRaces
   * RDS DimPeople
   * RDS DimSchoolYears
   * RDS DimGradeLevels
   * RDS DimAges

<figure><img src="../../.gitbook/assets/SigDispro_Setup_IP_Addresses.png" alt="A screenshot of the Advanced Editor in a database management software showing code for updating various tables (RDS ChildCount, RDS Membership, RDS.Placement, etc.) with new IP addresses and database names."><figcaption><p>Updating IP addresses and database names in the Advanced Editor.</p></figcaption></figure>

7. Click "Apply" then save the report after each query. Applying and saving after each query will allow you to troubleshoot easier if you run into issues with a single query. After refreshing, the data will be cached in the .pbix file.&#x20;
8. Close Power Query.

***

### Distribution

{% hint style="danger" %}
This report includes Student ID numbers and other personally identifiable information (PII) cached in the .pbix file. Ensure it is shared only with authorized individuals. Refer to your SEA’s policies and procedures before sharing.
{% endhint %}

While the .pbix can be sent to individuals with Power BI Desktop, CIID recommends that this report is distributed with internal state staff through an Online Power BI Workspace. Doing this ensures access can be limited to appropriate individuals, that the report cannot be edited, and provides multiple sharing options, such as embedding into a Teams Channel.

#### Online Power BI Workspace

1. Sign into office.com and select Power BI.
2. Create a new workspace.

<figure><img src="../../.gitbook/assets/SigDispro_Setup_CreateWorkspace.png" alt="A user interface displaying workspace creation options, including naming the workspace, adding a description, assigning it to a domain (optional), uploading an image (optional), and accessing advanced settings."><figcaption><p>Setting up a new workspace for productivity.<br></p></figcaption></figure>

3. Upload the .pbix file to the workspace.

<figure><img src="../../.gitbook/assets/SigDispro_Setup_Upload_Workspace.png" alt="A user interface displaying the Power BI service. The ‘Sig Dispro Test Workspace’ is highlighted. Options include ‘+ New’, ‘Upload’, ‘Create app’, and ‘Manage access’. Below these options, there is a menu for uploading a file with sources like ‘OneDrive for Business’, ‘SharePoint’, and ‘Browse’. The user is prompted to upload a .pbix file to the workspace."><figcaption><p>Screenshot of the Power BI service interface with a focus on the ‘Sig Dispro Test Workspace’.</p></figcaption></figure>

After the report is uploaded in the workspace, the dashboard will be available to use and share by clicking on the .pbix file.

<figure><img src="../../.gitbook/assets/SigDispro_Setup_Workspace.png" alt="A user interface showing a list of files within the ‘Sig Dispro Test Workspace’. There are three files listed, named ‘Significant Disproportionality Report #1’, with the type specified as ‘Report’ and owned by ‘Sig Dispro Test Workspace’. The most recent file is highlighted, indicating it is selected. Above the list, there are options to create new content, upload, or get data. On the right side of the screen, workspace settings and more actions can be accessed."><figcaption><p>Screenshot of a digital workspace with reports ready for use.</p></figcaption></figure>

4. Manage permissions by clicking "Share" and selecting the appropriate individuals.

<figure><img src="../../.gitbook/assets/SigDispro_Setup_Sharing_Button.png" alt="Power BI report showing the State Overview page with various charts and the &#x27;Share&#x27; button highlighted for managing permissions."><figcaption><p>Screenshot of the Significant Disproportionality Report in Power BI. Manage permissions by clicking 'Share' and selecting the appropriate individuals.</p></figcaption></figure>

5. Type in the name of the person you want to share with. Then click the method you would like to send through.

<figure><img src="../../.gitbook/assets/SigDispro_Setup_Sharing.png" alt="Power BI report showing the State Overview page with various charts and the &#x27;Send link&#x27; dialog box for sharing the report."><figcaption><p>Screenshot of the Significant Disproportionality Report in Power BI, showing the State Overview page and the 'Send link' dialog box, which allows users to share the report with colleagues via email, Teams, or by copying the link.</p></figcaption></figure>

***

### Refreshing Data&#x20;

Administrators of the report can refresh the data in different ways:

**Desktop .pbix file:** Click the refresh button to view updated data.

{% hint style="info" %}
If this report is being used in the workspace, after refreshing data, then click publish to allow authorized users to view the data.
{% endhint %}

Online Workspace: Go to the semantic model and click the refresh button.  &#x20;

<figure><img src="../../.gitbook/assets/SigDispro_Setup_Refreshing_Workspace.jpg" alt=""><figcaption><p>Refreshing the Semantic Model in the Sig Dispro Test Workspace.</p></figcaption></figure>

***

### Adjusting Years

By default, the report loads the latest three years of data. However, depending on when you access the report, some files' data may appear blank. If this happens, it may be helpful to load the previous three years _excluding_ the current year.

To adjust the report to view the previous three years (excluding the current year), follow these steps:

{% stepper %}
{% step %}
### Open the report in Power BI Desktop

<figure><img src="../../.gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>
{% endstep %}

{% step %}
### Under the 'Home' tab, click the table icon then 'Transform data' to take you to the Power Query page.&#x20;

<figure><img src="../../.gitbook/assets/image (6).png" alt=""><figcaption></figcaption></figure>
{% endstep %}

{% step %}
### In the left-hand panel under the 'Parameters' section, select the 'YearSelection' parameter.&#x20;

<figure><img src="../../.gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>
{% endstep %}

{% step %}
### Under the 'Current Value' dropdown, select 'Latest 3 years minus latest year'.

<figure><img src="../../.gitbook/assets/image (9).png" alt=""><figcaption></figcaption></figure>


{% endstep %}

{% step %}
### Click 'Close & Apply'


{% endstep %}
{% endstepper %}
