package irmagobridge

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"reflect"
	"strings"

	"github.com/go-errors/errors"
	"github.com/privacybydesign/irmago/irmaclient"
)

// IrmaMobileBridge is the iOS or Android native component that is used for message passing
type IrmaMobileBridge interface {
	DispatchFromGo(name string, payload string)
	DebugLog(message string)
}

var bridge IrmaMobileBridge
var client *irmaclient.Client
var appDataVersion = "v2"

// eventHandler maintains a sessionLookup for actions incoming
// from irma_mobile (see action_handler.go)
var bridgeEventHandler = &eventHandler{
	sessionLookup: map[int]*sessionHandler{},
}

// clientHandler is used for messages coming in from irmago (see client_handler.go)
var bridgeClientHandler = &clientHandler{}

// Prestart is invoked only on Android in MainActivity's onCreate, to initialize
// the Go binding at the earliest moment, instead of inside the Flutter plugin
func Prestart() {
	// noop
}

// Start is invoked from the native side, when the app starts
func Start(givenBridge IrmaMobileBridge, appDataPath string, assetsPath string) {
	defer recoverFromPanic()

	bridge = givenBridge

	// Check for user data directory, and create version-specific directory
	exists, err := pathExists(appDataPath)
	if err != nil || !exists {
		reportError(errors.WrapPrefix(err, "Cannot access app data directory", 0))
		return
	}

	appVersionDataPath := filepath.Join(appDataPath, appDataVersion)
	exists, err = pathExists(appVersionDataPath)
	if err != nil {
		reportError(errors.WrapPrefix(err, "Cannot check for app data path existence", 0))
		return
	}

	if !exists {
		os.Mkdir(appVersionDataPath, 0770)
	}

	// Initialize the client
	configurationPath := filepath.Join(assetsPath, "irma_configuration")
	client, err = irmaclient.New(appVersionDataPath, configurationPath, bridgeClientHandler)
	if err != nil {
		reportError(errors.WrapPrefix(err, "Cannot initialize client", 0))
		return
	}
}

func dispatchEvent(event interface{}) {
	jsonBytes, err := json.Marshal(event)
	if err != nil {
		reportError(errors.Errorf("Cannot marshal event payload: %s", err))
		return
	}

	eventName := strings.Title(reflect.TypeOf(event).Elem().Name())
	bridge.DebugLog("Sending event " + eventName)
	bridge.DispatchFromGo(eventName, string(jsonBytes))
}

func Stop() {
	client.Close()
}

func reportError(err *errors.Error) {
	message := fmt.Sprintf("%s\n%s", err.Error(), err.ErrorStack())

	// raven.CaptureError(err, nil)
	bridge.DebugLog(message)

	// We need to json encode the error, but cant do full error checking
	jsonBytes, err2 := json.Marshal(errorEvent{Exception: err.Error(), Stack: err.ErrorStack()})
	if err2 != nil {
		bridge.DebugLog(err2.Error())
	} else {
		bridge.DispatchFromGo("ErrorEvent", string(jsonBytes))
	}
}

// PathExists checks if the specified path exists.
func pathExists(path string) (bool, error) {
	_, err := os.Stat(path)
	if err == nil {
		return true, nil
	}
	if os.IsNotExist(err) {
		return false, nil
	}
	return true, err
}

func recoverFromPanic() {
	if e := recover(); e != nil {
		reportError(errors.New(e))
	}
}
