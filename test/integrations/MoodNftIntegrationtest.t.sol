// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftIntegrationTest is Test {
    MoodNft moodNft;
    string public constant HAPPY_SVG_Image_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+PGcgY2xhc3M9ImV5ZXMiPjxjaXJjbGUgY3g9IjcwIiBjeT0iODIiIHI9IjEyIi8+PGNpcmNsZSBjeD0iMTI3IiBjeT0iODIiIHI9IjEyIi8+PC9nPjxwYXRoIGQ9Im0xMzYuODEgMTE2LjUzYy42OSAyNi4xNy02NC4xMSA0Mi04MS41Mi0uNzMiIHN0eWxlPSJmaWxsOm5vbmU7IHN0cm9rZTogYmxhY2s7IHN0cm9rZS13aWR0aDogMzsiLz48L3N2Zz4=";

    string public constant SAD_SVG_Image_URI =
        "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAwcHgiIGhlaWdodD0iNDAwcHgiIHZpZXdCb3g9IjAgMCAxMDI0IDEwMjQiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHBhdGggZmlsbD0iIzMzMyIgZD0iTTUxMiA2NEMyNjQuNiA2NCA2NCAyNjQuNiA2NCA1MTJzMjAwLjYgNDQ4IDQ0OCA0NDggNDQ4LTIwMC42IDQ0OC00NDhTNzU5LjQgNjQgNTEyIDY0em0wIDgyMGMtMjA1LjQgMC0zNzItMTY2LjYtMzcyLTM3MnMxNjYuNi0zNzIgMzcyLTM3MiAzNzIgMTY2LjYgMzcyIDM3Mi0xNjYuNiAzNzItMzcyIDM3MnoiLz48cGF0aCBmaWxsPSIjRTZFNkU2IiBkPSJNNTEyIDE0MGMtMjA1LjQgMC0zNzIgMTY2LjYtMzcyIDM3MnMxNjYuNiAzNzIgMzcyIDM3MiAzNzItMTY2LjYgMzcyLTM3Mi0xNjYuNi0zNzItMzcyLTM3MnpNMjg4IDQyMWE0OC4wMSA0OC4wMSAwIDAgMSA5NiAwIDQ4LjAxIDQ4LjAxIDAgMCAxLTk2IDB6bTM3NiAyNzJoLTQ4LjFjLTQuMiAwLTcuOC0zLjItOC4xLTcuNEM2MDQgNjM2LjEgNTYyLjUgNTk3IDUxMiA1OTdzLTkyLjEgMzkuMS05NS44IDg4LjZjLS4zIDQuMi0zLjkgNy40LTguMSA3LjRIMzYwYTggOCAwIDAgMS04LTguNGM0LjQtODQuMyA3NC41LTE1MS42IDE2MC0xNTEuNnMxNTUuNiA2Ny4zIDE2MCAxNTEuNmE4IDggMCAwIDEtOCA4LjR6bTI0LTIyNGE0OC4wMSA0OC4wMSAwIDAgMSAwLTk2IDQ4LjAxIDQ4LjAxIDAgMCAxIDAgOTZ6Ii8+PHBhdGggZmlsbD0iIzMzMyIgZD0iTTI4OCA0MjFhNDggNDggMCAxIDAgOTYgMCA0OCA0OCAwIDEgMC05NiAwem0yMjQgMTEyYy04NS41IDAtMTU1LjYgNjcuMy0xNjAgMTUxLjZhOCA4IDAgMCAwIDggOC40aDQ4LjFjNC4yIDAgNy44LTMuMiA4LjEtNy40IDMuNy00OS41IDQ1LjMtODguNiA5NS44LTg4LjZzOTIgMzkuMSA5NS44IDg4LjZjLjMgNC4yIDMuOSA3LjQgOC4xIDcuNEg2NjRhOCA4IDAgMCAwIDgtOC40QzY2Ny42IDYwMC4zIDU5Ny41IDUzMyA1MTIgNTMzem0xMjgtMTEyYTQ4IDQ4IDAgMSAwIDk2IDAgNDggNDggMCAxIDAtOTYgMHoiLz4KPC9zdmc+ICA=";
    string public constant SAD_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjoiTW9vZCBOZnQiLCAiZGVzY3JpcHRpb24iOiJBbiBORlQgdGhhdCByZWZsZWN0cyB0aGUgbW9vZCBvZiB0aGUgb3duZXIsIDEwMCUgb24gQ2hhaW4hIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIm1vb2RpbmVzcyIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUIzYVdSMGFEMGlOREF3Y0hnaUlHaGxhV2RvZEQwaU5EQXdjSGdpSUhacFpYZENiM2c5SWpBZ01DQXhNREkwSURFd01qUWlJSGh0Ykc1elBTSm9kSFJ3T2k4dmQzZDNMbmN6TG05eVp5OHlNREF3TDNOMlp5SStQSEJoZEdnZ1ptbHNiRDBpSXpNek15SWdaRDBpVFRVeE1pQTJORU15TmpRdU5pQTJOQ0EyTkNBeU5qUXVOaUEyTkNBMU1USnpNakF3TGpZZ05EUTRJRFEwT0NBME5EZ2dORFE0TFRJd01DNDJJRFEwT0MwME5EaFROelU1TGpRZ05qUWdOVEV5SURZMGVtMHdJRGd5TUdNdE1qQTFMalFnTUMwek56SXRNVFkyTGpZdE16Y3lMVE0zTW5NeE5qWXVOaTB6TnpJZ016Y3lMVE0zTWlBek56SWdNVFkyTGpZZ016Y3lJRE0zTWkweE5qWXVOaUF6TnpJdE16Y3lJRE0zTW5vaUx6NDhjR0YwYUNCbWFXeHNQU0lqUlRaRk5rVTJJaUJrUFNKTk5URXlJREUwTUdNdE1qQTFMalFnTUMwek56SWdNVFkyTGpZdE16Y3lJRE0zTW5NeE5qWXVOaUF6TnpJZ016Y3lJRE0zTWlBek56SXRNVFkyTGpZZ016Y3lMVE0zTWkweE5qWXVOaTB6TnpJdE16Y3lMVE0zTW5wTk1qZzRJRFF5TVdFME9DNHdNU0EwT0M0d01TQXdJREFnTVNBNU5pQXdJRFE0TGpBeElEUTRMakF4SURBZ01DQXhMVGsySURCNmJUTTNOaUF5TnpKb0xUUTRMakZqTFRRdU1pQXdMVGN1T0MwekxqSXRPQzR4TFRjdU5FTTJNRFFnTmpNMkxqRWdOVFl5TGpVZ05UazNJRFV4TWlBMU9UZHpMVGt5TGpFZ016a3VNUzA1TlM0NElEZzRMalpqTFM0eklEUXVNaTB6TGprZ055NDBMVGd1TVNBM0xqUklNell3WVRnZ09DQXdJREFnTVMwNExUZ3VOR00wTGpRdE9EUXVNeUEzTkM0MUxURTFNUzQySURFMk1DMHhOVEV1Tm5NeE5UVXVOaUEyTnk0eklERTJNQ0F4TlRFdU5tRTRJRGdnTUNBd0lERXRPQ0E0TGpSNmJUSTBMVEl5TkdFME9DNHdNU0EwT0M0d01TQXdJREFnTVNBd0xUazJJRFE0TGpBeElEUTRMakF4SURBZ01DQXhJREFnT1RaNklpOCtQSEJoZEdnZ1ptbHNiRDBpSXpNek15SWdaRDBpVFRJNE9DQTBNakZoTkRnZ05EZ2dNQ0F4SURBZ09UWWdNQ0EwT0NBME9DQXdJREVnTUMwNU5pQXdlbTB5TWpRZ01URXlZeTA0TlM0MUlEQXRNVFUxTGpZZ05qY3VNeTB4TmpBZ01UVXhMalpoT0NBNElEQWdNQ0F3SURnZ09DNDBhRFE0TGpGak5DNHlJREFnTnk0NExUTXVNaUE0TGpFdE55NDBJRE11TnkwME9TNDFJRFExTGpNdE9EZ3VOaUE1TlM0NExUZzRMalp6T1RJZ016a3VNU0E1TlM0NElEZzRMalpqTGpNZ05DNHlJRE11T1NBM0xqUWdPQzR4SURjdU5FZzJOalJoT0NBNElEQWdNQ0F3SURndE9DNDBRelkyTnk0MklEWXdNQzR6SURVNU55NDFJRFV6TXlBMU1USWdOVE16ZW0weE1qZ3RNVEV5WVRRNElEUTRJREFnTVNBd0lEazJJREFnTkRnZ05EZ2dNQ0F4SURBdE9UWWdNSG9pTHo0S1BDOXpkbWMrSUNBPSJ9";
    DeployMoodNft deployer;
    address USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenURIIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }

    function testFlipTokenToSad() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.flipMood(0);

        console.log(moodNft.tokenURI(0));

        assertEq(keccak256(abi.encodePacked(moodNft.tokenURI(0))), keccak256(abi.encodePacked(SAD_SVG_URI)));
    }
}
