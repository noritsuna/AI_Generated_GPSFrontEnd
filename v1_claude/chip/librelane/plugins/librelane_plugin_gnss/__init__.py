"""LibreLane plugin for the GNSS AFE chip: chip-level straps between the analog pad block
(gf180mcu_gnss_io__afe_rf) and the analog hard macro (gnss_afe_analog)."""
import os
from librelane.steps.step import Step
from librelane.steps.odb import OdbpyStep


@Step.factory.register()
class GnssAnalogStraps(OdbpyStep):
    """
    Straight Metal2 straps from the core-side Metal2 pins of the analog pad block (VDDA,
    VSS and RF) down to the Metal2 landing pins on the top edge of the analog macro.  The
    supplies become special wires of their nets; the RF net is made special, so the signal
    router leaves the (wide, short) strap alone.
    """

    id = "Odb.GnssAnalogStraps"
    name = "GNSS analog pad straps"

    def get_script_path(self):
        return os.path.join(os.path.dirname(__file__), "analog_straps.py")
