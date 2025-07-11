/****** Object:  View [RDS].[vwSignificantDisproportionality_C143]    Script Date: 6/12/2024 9:04:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [RDS].[vwSignificantDisproportionality_C143] AS

--================================================================================================
-- Discipline
--================================================================================================
WITH
DisciplineFilteredFactData 
AS
	(
SELECT		 Fact.K12StudentId
					,Fact.PrimaryDisabilityTypeID 
					,Fact.SchoolYearId
					,rdp.K12StudentStudentIdentifierState
					,Schools.SchoolIdentifierSea
					,Fact.LeaId
					,Fact.RaceId
					,LEAs.LeaIdentifierSea
					,LEAs.LeaIdentifierNces
					,Fact.IdeaStatusId					
					,Fact.GradeLevelId
					,Fact.AgeId					
					,rdds.DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode
					,rdds.DisciplinaryActionTakenEdFactsCode
					,rdds.IdeaInterimRemovalEdFactsCode
					,rdds.IdeaInterimRemovalReasonEdFactsCode
					,rdds.EducationalServicesAfterRemovalEdFactsCode
					,Fact.DurationOfDisciplinaryAction
					,Fact.DisciplineCount
					,1 AS DisciplineStudentCount
					,SeaId
		FROM   		RDS.FactK12StudentDisciplines	Fact
		JOIN		RDS.DimSchoolYears				SchoolYears		ON Fact.SchoolYearId		= SchoolYears.DimSchoolYearId	
		LEFT JOIN  rds.DimPeople					rdp				on fact.K12StudentId		= rdp.DimPersonId
		LEFT JOIN  RDS.DimLeas                     LEAs            ON Fact.LeaId               = LEAs.DimLeaId
		LEFT JOIN  RDS.DimK12Schools               Schools         ON Fact.K12SchoolId         = Schools.DimK12SchoolId
		LEFT JOIN  RDS.DimIdeaStatuses				rdis 			ON fact.IdeaStatusId		= rdis.DimIdeaStatusId
		LEFT JOIN   RDS.DimAges                     Ages            ON Fact.AgeId               = Ages.DimAgeId      
		LEFT JOIN   RDS.DimRaces                    Races           ON Fact.RaceId              = Races.DimRaceId
		LEFT JOIN  RDS.DimIdeaDisabilityTypes		IDEADisability  ON Fact.PrimaryDisabilityTypeId = IDEADisability.DimIdeaDisabilityTypeId
		LEFT JOIN rds.DimDisciplineStatuses		rdds 			ON fact.DisciplineStatusId = rdds.DimDisciplineStatusId
		WHERE 1 = 1
		
		AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode <> 'PPPS'
			and rdis.IdeaIndicatorEdFactsCode = 'IDEA'
			and (rdds.DisciplineMethodOfChildrenWithDisabilitiesCode <> 'MISSING'
				or rdds.DisciplinaryActionTakenCode IN ('03086', '03087')
				or rdds.IdeaInterimRemovalReasonCode <> 'MISSING'
				or rdds.IdeaInterimRemovalCode <> 'MISSING')
		AND Ages.AgeValue >= 3 and Ages.AgeValue <= 21
	),
AggregateC143
AS
	(
		SELECT		 fact.K12StudentId								
					,fact.SchoolYearId
					,fact.LeaId
					,fact.RaceId
					,fact.LeaIdentifierSea
					,fact.LeaIdentifierNces
					,sum(isnull(fact.DisciplineCount, 0)) AS DisciplineCount
					
		FROM		DisciplineFilteredFactData AS fact
		GROUP BY	fact.SchoolYearId, fact.LeaId, fact.LeaIdentifierSea,LeaIdentifierNces, fact.K12StudentId, fact.RaceId
		HAVING 		SUM(fact.DurationOfDisciplinaryAction) >= 0.5 
	),
FlattenedC143
AS
	(					
		SELECT		 
					C143.LeaId
					,C143.RaceID
					,Count(C143.DisciplineCount) AS DisciplineCount
					,C143.SchoolYearID
					,C143.LeaIdentifierSea
					,C143.LeaIdentifierNces
		FROM		AggregateC143 AS C143
		GROUP BY	C143.SchoolYearID, C143.LeaId, C143.RaceID, C143.LeaIdentifierSea, C143.LeaIdentifierNces
	),
LEAC143
AS 
	(
		SELECT					
					c143.SchoolYearId
					,c143.LeaId
					,c143.RaceId
					,c143.LeaIdentifierSea
					,c143.LeaIdentifierNces
					,c143.DisciplineCount
		FROM		FlattenedC143 AS c143
	)

	SELECT		*
	FROM		LEAC143			AS c143
GO


