Indented Logify can be turn on and off, and each line is indented so you can see the methods each method calls.

But it's limited in the same manner as logify.pl, as it will only log methods you have logified (using the modified version of logify.pl thats in this repository).
This means you have to have an idea of what methods are called before using this.

Eg, finding what happens when a cell in spotlight is selected/tapped, you would:

* Process SPSearchResult, SBSearchModel and SPSearchResultDeserializer with indentedLogify.pl

* Combine the outputted .xm files into a tweak

* hook the method you want to start logging at, start the logging, call the original method and end the logging:

        %hook SBSearchController
            -(void)tableView:(id)view didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
                START_INDENTED_LOGGING(SEARCH_LOG);//SEARCH_LOG, is just something to identify  this section in the log, it could be anything.
                %orig;
                END_INDENTED_LOGGING(SEARCH_LOG);
            }
        %end

* A log will then be produced at the location specified in IndentedLogify.h, such as:  
(you can see it's `[SBSearchModel _shouldDisplayWebSearchResults]` (and not `[SBSearchModel sectionIsWebSearch:]`) that calls `[SBSearchModel isAbleToShowWebSearchResults]`).

        START: SEARCH_LOG
            [SBSearchModel sharedInstance]
            [SBSearchModel sectionIsWebSearch:]
                [SBSearchModel _shouldDisplayWebSearchResults]
                    [SBSearchModel isAbleToShowWebSearchResults]
                [SBSearchModel numberOfSections]
                    [SBSearchModel _resultSectionCount]
                    [SBSearchModel shouldDisplayApplicationSearchResults]
                    [SBSearchModel _shouldDisplayWebSearchResults]
                        [SBSearchModel isAbleToShowWebSearchResults]
            [SBSearchModel sectionIsApp:appOffset:]
                [SBSearchModel shouldDisplayApplicationSearchResults]
            [SPSearchResult init]
            [SBSearchModel groupForSection:]
            [SPSearchResultDeserializer deserializeResultAtIndex:toCursor:]
                [SPSearchResultDeserializer readResultIntoCursor:]
                    [SPSearchResult setResultDomain:]
                    [SPSearchResult setResultDisplayIdentifier:]
                    [SPSearchResult setTitle:]
                    [SPSearchResult setSubtitle:]
                    [SPSearchResult setSummary:]
                    [SPSearchResult setAuxiliaryTitle:]
                    [SPSearchResult setAuxiliarySubtitle:]
                    [SPSearchResult setIdentifier:]
                    [SPSearchResult setURL:]
                    [SPSearchResult setBadge:]
                    [SPSearchResultDeserializer read:maxLength:]
                    [SPSearchResultDeserializer read:maxLength:]
                    [SPSearchResult setResultDomain:]
                    [SPSearchResultDeserializer read:maxLength:]
                    [SPSearchResultDeserializer read:maxLength:]
                    [SPSearchResultDeserializer readBytes:]
                    [SPSearchResult setResultDisplayIdentifier:]
                    [SPSearchResultDeserializer read:maxLength:]
                    [SPSearchResultDeserializer read:maxLength:]
                    [SPSearchResultDeserializer readBytes:]
                    [SPSearchResult setTitle:]
                    [SPSearchResultDeserializer read:maxLength:]
                    [SPSearchResultDeserializer read:maxLength:]
                    [SPSearchResult setIdentifier:]
                    [SPSearchResultDeserializer read:maxLength:]
                    [SPSearchResult setDomain:]
            [SPSearchResult domain]
            [SPSearchResult resultDomain]
            [SPSearchResult resultDisplayIdentifier]
            [SPSearchResult dealloc]
            [SBSearchModel resetClearSearchTimer]
            [SBSearchModel startClearSearchTimer]
                [SBSearchModel hasQueryString]
                [SBSearchModel hasSearchResults]
                    [SBSearchModel numberOfSections]
                        [SBSearchModel _resultSectionCount]
                        [SBSearchModel shouldDisplayApplicationSearchResults]
                        [SBSearchModel _shouldDisplayWebSearchResults]                 
                            [SBSearchModel isAbleToShowWebSearchResults]
                [SBSearchModel _updateClearSearchTimerFireDate]
        END: SEARCH_LOG

